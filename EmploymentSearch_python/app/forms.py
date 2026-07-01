"""
Definition of forms.
"""

from django import forms
from django.contrib.auth.forms import AuthenticationForm
from django.utils.translation import gettext_lazy as _
from .models import Company, Position, Contact, Person
from collections import OrderedDict


class BootstrapAuthenticationForm(AuthenticationForm):
    """Authentication form which uses boostrap CSS."""
    username = forms.CharField(max_length=254,
                               widget=forms.TextInput({
                                   'class': 'form-control',
                                   'placeholder': 'User name'}))
    password = forms.CharField(label=_("Password"),
                               widget=forms.PasswordInput({
                                   'class': 'form-control',
                                   'placeholder':'Password'}))

class CompanyForm(forms.ModelForm):
    class Meta:
        model = Company
        # map model field names to form fields
        fields = ['companyname','phone','link','address1','address2','city','state','zip','comment']
        labels = {
            'companyname': 'Company Name',
            'link': 'Website',
            'zip': 'ZIP Code',
        }
        widgets = {
            'company_key': forms.HiddenInput(), 
            'companyname': forms.TextInput(attrs={'class':'form-control wide-input', 'style':'margin-bottom:5px'}),
            'phone': forms.TextInput(attrs={'class':'form-control wide-input', 'style':'margin-bottom:5px'}),
            'link': forms.Textarea(attrs={'class':'form-control', 'rows':4, 'style': 'margin-bottom:5px', 'cols':80}),
            'address1': forms.TextInput(attrs={'class':'form-control wide-input', 'style': 'margin-bottom:5px'}),
            'address2': forms.TextInput(attrs={'class':'form-control wide-input', 'style': 'margin-bottom:5px'}),
            'city': forms.TextInput(attrs={'class':'form-control wide-input', 'style':'margin-bottom:5px'}),
            'state': forms.TextInput(attrs={'class':'form-control wide-input', 'style':'margin-bottom:5px'}),
            'zip': forms.TextInput(attrs={'class':'form-control wide-input', 'style':'margin-bottom:5px'}),
            'comment': forms.Textarea(attrs={'class':'form-control', 'rows':4, 'style': 'margin-bottom:5px', 'cols':80}),
            }


class PositionForm(forms.ModelForm):
    # keep FK hidden so the actual value posts
    company_key = forms.ModelChoiceField(queryset=Company.objects.all(), widget=forms.HiddenInput())
    # display-only textbox
    company_display = forms.CharField(required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'readonly': 'readonly'  # use 'disabled' if you also add a hidden field for submission
    }))

    class Meta:
        model = Position
        fields = ['position_key','company_key', 'position', 'note', 'rate', 'link', 'applicationdate', 'lastcontactdate', 'status', 'statusdate']
        labels = {
            'position': 'Job Title',
            'note': 'Role',
            'rate': 'Salary/Rate',
            'link': 'Job Posting Link',
            'applicationdate': 'Application Date',
            'lastcontactdate': 'Last Contact Date',
            'status': 'Status',
            'statusdate': 'Status Date',
            }
        widgets = {
            'position_key': forms.HiddenInput(),
            'company_key': forms.HiddenInput(), 
            'position': forms.TextInput(attrs={'class':'form-control wide-input', 'style':'margin-top:12px; margin-bottom:10px'}),
            'note': forms.Textarea(attrs={'class':'form-control', 'style': 'margin-bottom:10px', 'rows':4}),
            'rate': forms.TextInput(attrs={'class':'form-control wide-input', 'style': 'margin-bottom:10px'}),
            'link': forms.Textarea(attrs={'class':'form-control', 'rows':4, 'style': 'margin-bottom:10px', 'cols':80}),
            'applicationdate': forms.SelectDateWidget(attrs={'class':'date-select', 'style': 'margin-top:0px; margin-bottom:10px'}),
            'lastcontactdate': forms.SelectDateWidget(attrs={'class':'date-select', 'style': 'margin-top:0px; margin-bottom:10px'}),
            'status': forms.TextInput(attrs={'class':'form-control wide-input', 'style':'margin-bottom:10px'}),
            'statusdate': forms.SelectDateWidget(attrs={'class':'date-select', 'style': 'margin-top:0px; margin-bottom:10px'}),
            }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        company = None

        # 1) If the form is bound to an instance (editing), get instance relation
        if getattr(self, 'instance', None) and getattr(self.instance, 'company_key', None):
            company = self.instance.company_key

        # 2) Otherwise check initial or posted value (could be pk or Company)
        if not company:
            initial_val = self.initial.get('company_key') or self.data.get('company_key')
            if isinstance(initial_val, Company):
                company = initial_val
            elif initial_val:
                company = Company.objects.filter(pk=initial_val).first()

        # set display name if we found a company
        if company:
            self.fields['company_display'].initial = getattr(company, 'companyname', str(company))
            self.fields['company_display'].label = "Company Name"
            if not hasattr(self.fields, 'move_to_end'):
                self.fields = OrderedDict(self.fields)
            self.fields.move_to_end('company_display', last=False)