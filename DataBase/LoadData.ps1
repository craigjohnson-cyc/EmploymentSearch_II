# This Script will:
# •	Read a CSV file (run time parameter or ask at execution?)
# •	parse each record into data records for DataBase
# • Insert into the EmploymentSearch DataBase


Function Main
{
    # Include commonly used functions
    #Import-Module "C:\Users\Lenovo\source\repos\Powershell\PowerShell-Scripts\PowerShell` Scripts\FuncLib.ps1"
    . "$PSScriptRoot\FuncLib.ps1"

    # Define DataBase connections
    $dataBaseServer = "LENOVONOTEBOOK\SQLEXPRESS"
    $dataBaseName = "EmpSearch"

    #TODO 1. Read all CSV file names into an array
    #        Then process each file

    # Get CSV File name
    $inputFile = "C:\Users\Lenovo\source\repos\EmploymentSearch\DataBase\2026aplications.csv"

    $data = Import-Csv -Path $inputFile -Delimiter ';'

    $errorCount = 0

    foreach ($row in $data)
    {
        $found = $false
        #Clean up for SQL
        $row.Company = $row.Company.Replace("'", "\''")
        try
        {
            $row.Comment = $row.Comment.Replace("'", "\''")
        }
        catch
        {
            #No Action taken
        }
        try
        {
            $row.Link = $row.Link.Replace("'", "\''")
        }
        catch
        {
            #No Action taken
        }

        # Check for existance of the company before inserting as there 
        # is the posibility of multiple positions within a single company.
        $sqlCommand = "Select Top 1 (Company_Key) from [dbo].[Company] where ltrim(rtrim(Lower(CompanyName))) = '{0}' Order By Company_Key Desc" -f $row.Company.ToLower().Trim()
        try
        {
            $returnValue = Invoke-SQL -dataSource $dataBaseServer -database $dataBaseName -sqlCommand $sqlcommand
            $found = $returnValue.Company_Key -gt 0
        }
        catch
        {
            $found = $false
        }

        #Insert Company
        if ($found)
        {
            $company_Key = $returnValue.Company_Key
        }
        else
        {
            $company = CreateCompanyObj $row.Company
            $sqlCommand = "Insert Into [dbo].[Company] 
                (CompanyName, Link, Phone, Address1, Address2, City, State, Zip) values ('{0}', '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}')
                select Top 1 (Company_Key) from [dbo].[Company] where CompanyName = '{0}' Order By Company_Key Desc
                " -f $company.CompanyName, $company.Link, $company.Phone, $company.Address1, $company.Address2, $company.City, $company.State, $company.Zip 
            try
            {
                $returnValue = Invoke-SQL -dataSource $dataBaseServer -database $dataBaseName -sqlCommand $sqlcommand
            }
            catch
            {
                $errorCount+=1
                ReportError $_ $sqlCommand
                Break
            }
            $company_Key = $returnValue.Company_Key
        }

        #Insert Position
        $position = CreatePositionObj $row.Position $row.Rate $row.Link $row.ApplicationDate $row.Status $row.StatusDate $company_Key $row.Comment
        $sqlCommand = "
            Insert Into [dbo].[Position] (Company_Key, Position, Rate, Link, ApplicationDate, LastContactDate, Status, StatusDate, Note)
                   Values ({0}, '{1}', '{2}', '{3}', '{4}', '{5}', '{6}', '{7}', '{8}' ) 
            Select Top 1 (Position_Key) from [dbo].[Position] where Company_Key = {0} and Position = '{1}' Order By Position_Key Desc
            " -f $position.Company_Key, $position.Position, $position.Rate, $position.Link, $position.ApplicationDate, $position.LastContactDate, $position.Status, $position.StatusDate, $position.Note
        try
        {
            $returnValue = Invoke-SQL -dataSource $dataBaseServer -database $dataBaseName -sqlCommand $sqlcommand
        }
        catch
        {
            $errorCount+=1
            ReportError $_ $sqlCommand
            Break
        }
        $position_Key = $returnValue.Position_Key

        #Insert Contact
        $appSubmitted = 'Application Submitted'
        $contact = CreateContactObj $row.ApplicationDate $appSubmitted $position_Key
        $sqlCommand = "
            Insert Into [dbo].[Contact] (Position_Key, ContactDate, Description, Person_Key, ContactMethod)
                   Values ({0}, '{1}', '{2}', {3}, '{4}' ) " -f $position_Key, $contact.ContactDate, $contact.Description, $contact.Person_Key, $contact.ContactMethod
        try
        {
            $a = Invoke-SQL -dataSource $dataBaseServer -database $dataBaseName -sqlCommand $sqlcommand
        }
        catch
        {
            $errorCount+=1
            ReportError $_ $sqlCommand
            Break
        }


        # Most records wil import with just a Application Submitted status, However, there will
        # be some which have received a Rejection.  In these cases, insert a second Contact record
        # to record the Rejection
        try
        {
            if ($row.Status.ToLower().Trim() -eq "rejection")
            {
                $sqlCommand = "
                    Insert Into [dbo].[Contact] (Position_Key, ContactDate, Description, Person_Key, ContactMethod)
                           Values ({0}, '{1}', '{2}', {3}, '{4}'  ) " -f $position_Key, $row.StatusDate, $row.Status, $contact.Person_Key, $contact.ContactMethod
                $a = Invoke-SQL -dataSource $dataBaseServer -database $dataBaseName -sqlCommand $sqlcommand
            }
        }
        catch
        {
            # No Action taken as this was caused by No status in the input file
        }
    }

}

function CreateCompanyObj()
{
    param ($company)
    
    $companyObj = New-Object PSObject
    $companyObj | add-member -type NoteProperty -Name Company_Key -Value 0
    $companyObj | add-Member -type NoteProperty -Name CompanyName -Value $company.Trim()
    $companyObj | add-member -type NoteProperty -Name Link -Value ""
    $companyObj | add-member -type NoteProperty -Name Phone -Value ""
    $companyObj | add-member -type NoteProperty -Name Address1 -Value ""
    $companyObj | add-member -type NoteProperty -Name Address2 -Value ""
    $companyObj | add-member -type NoteProperty -Name City -Value ""
    $companyObj | add-member -type NoteProperty -Name State -Value ""
    $companyObj | add-member -type NoteProperty -Name Zip -Value ""

    return $companyObj
}

function CreatePositionObj()
{
    param ($position, $rate, $link, $AppDate, $status, $statusDate, $company_Key, $note)
    
    $positionObj = New-Object PSObject
    $positionObj | add-member -type NoteProperty -Name Position_Key -Value 0
    $positionObj | add-Member -type NoteProperty -Name Company_Key -Value $company_Key
    $positionObj | add-member -type NoteProperty -Name Position -Value $position.Trim()
    if([string]::IsNullOrEmpty($note.Trim()) )
        {$positionObj | add-member -type NoteProperty -Name Note -Value ""}
    else
        {$positionObj | add-member -type NoteProperty -Name Note -Value $note.Trim()}
    $positionObj | add-member -type NoteProperty -Name Rate -Value $rate.Trim()
    $positionObj | add-member -type NoteProperty -Name Link -Value $link.Trim()
    $positionObj | add-member -type NoteProperty -Name ApplicationDate -Value $AppDate.Trim()
    $positionObj | add-member -type NoteProperty -Name LastContactDate -Value $statusDate.Trim()
    $positionObj | add-member -type NoteProperty -Name Status -Value $status.Trim()
    $positionObj | add-member -type NoteProperty -Name StatusDate -Value $statusDate.Trim()

    return $positionObj
}

function CreateContactObj()
{
    param ($contactDate, $contactNote, $position_Key)
    
    $contactObj = New-Object PSObject
    $contactObj | add-member -type NoteProperty -Name Contact_Key -Value 0
    $contactObj | add-member -type NoteProperty -Name Position_Key -Value $position_Key
    $contactObj | add-Member -type NoteProperty -Name Person_Key -Value 0
    $contactObj | add-Member -type NoteProperty -Name ContactMethod -Value ""
    $contactObj | Add-Member -type NoteProperty -Name ContactDate -Value $contactDate.Trim()
    $contactObj | add-member -type NoteProperty -Name Description -Value $contactNote.Trim()

    return $contactObj
}

# Script begins here:  Execute Function Main
Main