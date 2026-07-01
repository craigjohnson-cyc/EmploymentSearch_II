"""
Definition of models.
"""

from dataclasses import dataclass
from datetime import date

from django.db import models

# Create your models here.
# @dataclass

class Company(models.Model):
    company_key = models.AutoField(db_column='Company_Key', primary_key=True)  
    companyname = models.CharField(db_column='CompanyName', max_length=200, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    phone = models.CharField(db_column='Phone', max_length=50, blank=True, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    link = models.URLField(db_column='Link', blank=True)  
    address1 = models.CharField(db_column='Address1', max_length=200, blank=True, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    address2 = models.CharField(db_column='Address2', max_length=200, blank=True, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    city = models.CharField(db_column='City', max_length=100, blank=True, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    state = models.CharField(db_column='State', max_length=2, blank=True, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    zip = models.CharField(db_column='Zip', max_length=10, blank=True, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    comment = models.TextField(db_column='Comment', blank=True, db_collation='SQL_Latin1_General_CP1_CI_AS')  

    def __str__(self):
        return self.companyname

    class Meta:
        managed = False
        db_table = 'Company'


class Position(models.Model):
    position_key = models.AutoField(db_column='Position_Key', primary_key=True)  
    company_key = models.ForeignKey('Company', on_delete=models.CASCADE, db_column='Company_Key')  
    position = models.CharField(db_column='Position', max_length=200, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    note = models.TextField(db_column='Note', db_collation='SQL_Latin1_General_CP1_CI_AS')  
    rate = models.CharField(db_column='Rate', max_length=25, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    link = models.TextField(db_column='Link', db_collation='SQL_Latin1_General_CP1_CI_AS')  
    applicationdate = models.DateTimeField(db_column='ApplicationDate')  
    lastcontactdate = models.DateTimeField(db_column='LastContactDate')  
    status = models.CharField(db_column='Status', max_length=10, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    statusdate = models.DateTimeField(db_column='StatusDate')  

    class Meta:
        managed = False
        db_table = 'Position'

class Contact(models.Model):
    contact_key = models.AutoField(db_column='Contact_key', primary_key=True)  
    position_key = models.ForeignKey('Position', on_delete=models.CASCADE, db_column='Position_key')  
    person_key = models.ForeignKey('Person', on_delete=models.CASCADE, db_column='Person_key', null=True)  
    contactmethod = models.CharField(db_column='ContactMethod', max_length=5, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    contactdate = models.DateTimeField(db_column='ContactDate')  
    description = models.TextField(db_column='Description', db_collation='SQL_Latin1_General_CP1_CI_AS')  

    class Meta:
        managed = False
        db_table = 'Contact'

class Person(models.Model):
    person_key = models.AutoField(db_column='Person_key', primary_key=True)  
    position_key = models.ForeignKey('Position', on_delete=models.CASCADE, db_column='Position_key')  
    company_key = models.ForeignKey('Company', on_delete=models.CASCADE, db_column='Company_key')  
    name = models.CharField(db_column='Name', max_length=50, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    phoneoffice = models.CharField(db_column='PhoneOffice', max_length=13, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    phonecell = models.CharField(db_column='PhoneCell', max_length=13, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    preferedphone = models.CharField(db_column='PreferedPhone', max_length=6, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    preferedcontact = models.CharField(db_column='PreferedContact', max_length=6, db_collation='SQL_Latin1_General_CP1_CI_AS')  
    email = models.TextField(db_column='Email', db_collation='SQL_Latin1_General_CP1_CI_AS')  
    linkedin = models.TextField(db_column='LinkedIn', db_collation='SQL_Latin1_General_CP1_CI_AS')  
    comment = models.TextField(db_column='Comment', db_collation='SQL_Latin1_General_CP1_CI_AS')  

    class Meta:
        managed = False
        db_table = 'Person'


# class Company(models.Model):
#     Company_key: int = models.AutoField(primary_key=True)
#     CompanyName: str = models.CharField(max_length=50)
#     Phone: str = models.CharField(max_length=13)
#     Link: str = models.TextField()
#     Address1: str = models.CharField(max_length=50)
#     Address2: str = models.CharField(max_length=50)
#     City: str = models.CharField(max_length=30)
#     State: str = models.CharField(max_length=2)
#     Zip: str = models.CharField(max_length=10)
#     Comment: str = models.TextField()

#     class Meta:
#         db_table = 'Company'

# class Position(models.Model):
#     Position_key: int = models.AutoField(primary_key=True)
#     Company_key: int = models.IntegerField()
#     Position: str = models.CharField(max_length=200)
#     Note: str = models.TextField()
#     Rate: str = models.CharField(max_length=25)
#     Link: str = models.TextField()
#     ApplicationDate: date = models.DateField()
#     LastContactDate: date = models.DateField()
#     Status: str = models.CharField(max_length=10)
#     StatusDate: date = models.DateField()

    # class Meta:
    #     db_table = 'Position'


# class Contact(models.Model):
#     Contact_key: int = models.AutoField(primary_key=True)
#     Position_key: int = models.IntegerField()
#     Person_key: int = models.IntegerField()
#     ContactMethod: str = models.CharField(max_length=5)
#     ContactDate: date = models.DateField()
#     Description: str = models.TextField()

#     class Meta:
#         db_table = 'Contact'


# class Person(models.Model):
#     Person_key: int = models.AutoField(primary_key=True)
#     Position_key: int = models.IntegerField()
#     Company_key: int = models.IntegerField()
#     Name: str = models.CharField(max_length=50)
#     PhoneOffice: str = models.CharField(max_length=13)
#     PhoneCell: str = models.CharField(max_length=13)
#     PreferedPhone: str = models.CharField(max_length=6)
#     PreferedContact: str = models.CharField(max_length=6)
#     Email: str = models.TextField()
#     LinkedIn: str = models.TextField()
#     Comment: str = models.TextField()

#     class Meta:
#         db_table = 'Person'
