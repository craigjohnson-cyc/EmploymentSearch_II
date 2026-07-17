"""
Definition of views.
"""

from datetime import datetime
from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpRequest
from django.views.decorators.http import require_POST
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.core.paginator import Paginator
import json
from django.utils import timezone
from .forms import CompanyForm, PositionForm
from .models import Contact, Position, Person, Company


def home(request):
    """Renders the home page."""
    assert isinstance(request, HttpRequest)
    # include companies for the index dropdown
    companies = Company.objects.all().order_by('companyname')
    return render(
        request,
        'app/index.html',
        {
            'title': 'Home Page',
            'year': datetime.now().year,
            'companies': companies,
        }
    )

def contact(request):
    """Renders the contact page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/contact.html',
        {
            'title':'Contact',
            'message':'Your contact page.',
            'year':datetime.now().year,
        }
    )

def about(request):
    """Renders the about page."""
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/about.html',
        {
            'title':'About',
            'message':'Your application description page.',
            'year':datetime.now().year,
        }
    )

# CRUD views for Companyu model

def company_list(request):
    companies = Company.objects.all().order_by('companyname')
    paginator = Paginator(companies, 17)               # 17 rows per page
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)         # safe: handles invalid page numbers
    return render(request, 'company_list.html', {'page_obj': page_obj})


def company_search(request):
    """AJAX endpoint: return a rendered partial list of companies matching q."""
    q = request.GET.get('q', '').strip()
    companies = Company.objects.all().order_by('companyname')
    if q:
        companies = companies.filter(companyname__icontains=q)[:20]
    html = render_to_string('companies/_search_results.html', {'companies': companies}, request=request)
    return JsonResponse({'ok': True, 'html': html})


def company_create(request):
    # Use CompanyForm for consistency with company_update and to provide an empty form for GET
    if request.method == "POST":
        form = CompanyForm(request.POST)
        if form.is_valid():
            saved = form.save()
            # after saving, stay on the company form page showing the saved company (edit mode)
            form = CompanyForm(instance=saved)
            positions = Position.objects.filter(company_key=saved.company_key)
            if request.headers.get('x-requested-with') == 'XMLHttpRequest':
                form_html = render_to_string('_company_form_wrapper.html', {'form': form, 'company': saved}, request=request)
                positions_html = render_to_string('_positions_grid.html', {'positions': positions}, request=request)
                return JsonResponse({'ok': True, 'form_html': form_html, 'positions_html': positions_html, 'message': 'Company saved successfully'})
            return render(request, "company_form.html", {"form": form, "company": saved, "positions": positions})
    else:
        form = CompanyForm()

    return render(request, "company_form.html", {"form": form})


# def company_update(request, id):
#     company = get_object_or_404(Company, Company_key=id)
#     if request.method == "POST":
#        company.Company_key=request.POST["Company_key"]
#        company.CompanyName=request.POST["CompanyName"]
#        company.Phone=request.POST["Phone"]
#        company.Link=request.POST["Link"]
#        company.Address1=request.POST["Address1"]
#        company.Address2=request.POST["Address2"]
#        company.City=request.POST["City"]
#        company.State=request.POST["State"]
#        company.Zip=request.POST["Zip"]
#        company.Comment=request.POST["Comment"]
#        company.save()
#        return redirect("app/company_list")
#     return render(request, "app/company_form.html", {"company": company})

def company_update(request, id):
    company = get_object_or_404(Company, pk=id)
    positions = Position.objects.filter(company_key=company.company_key)

    if request.method == "POST":
        if 'cancel' in request.POST:
            return render(request, "company_form.html", {"form": CompanyForm(instance=company), "company": company, "positions": positions})
        form = CompanyForm(request.POST, instance=company)
        if form.is_valid():
            saved = form.save()
            # After saving, stay on the company form page showing saved data
            form = CompanyForm(instance=saved)
            positions = Position.objects.filter(company_key=saved.company_key)
            if request.headers.get('x-requested-with') == 'XMLHttpRequest':
                form_html = render_to_string('_company_form_wrapper.html', {'form': form, 'company': saved}, request=request)
                positions_html = render_to_string('_positions_grid.html', {'positions': positions}, request=request)
                return JsonResponse({'ok': True, 'form_html': form_html, 'positions_html': positions_html, 'message': 'Company saved successfully'})
            return render(request, "company_form.html", {"form": form, "company": saved, "positions": positions})
        else:
            # return the form with errors so client can replace
            if request.headers.get('x-requested-with') == 'XMLHttpRequest':
                form_html = render_to_string('_company_form_wrapper.html', {'form': form, 'company': company}, request=request)
                positions_html = render_to_string('_positions_grid.html', {'positions': positions}, request=request)
                return JsonResponse({'ok': False, 'form_html': form_html, 'positions_html': positions_html, 'message': 'Validation errors - please correct and try again'})
            return render(request, "company_form.html", {"form": form, "company": company, "positions": positions})
    else:
        form = CompanyForm(instance=company)
    return render(request, "company_form.html", {"form": form, "company": company, "positions": positions})


def company_delete(request, id):
    company = get_object_or_404(Company, company_key=id)
    company.delete()
    return redirect("company_list")

# CRUD views for Contact model

def contact_list(request):
    contacts = Contact.objects.all()
    return render(request, "contact_list.html", {"contacts": contacts})

def contact_create(request):
    if request.method == "POST":
            Contact.objects.create(
            position_key=request.POST["position_key"],
            person_key = request.POST["person_key"],
            contactMethod=request.POST["contactMethod"],
            contactDate=request.POST["contactDate"],
            description=request.POST["description"]
            )
            return redirect("contact_list")
    return render(request, "contact_form.html")

def contact_update(request, id):
    contact = get_object_or_404(Contact, contact_key=id)
    if request.method == "POST":
       contact.position_key=request.POST["position_key"]
       contact.person_key = request.POST["person_key"]
       contact.contactMethod=request.POST["contactMethod"]
       contact.contactDate=request.POST["contactDate"]
       contact.description=request.POST["description"]
       contact.save()
       return redirect("contact_list")
    return render(request, "contact_form.html", {"contact": contact})

def contact_delete(request, id):
    contact = get_object_or_404(Contact, contact_key=id)
    contact.delete()
    return redirect("contact_list")


# CRUD views for Position model

def position_list(request):
    positions = Position.objects.all()
    return render(request, "position_list.html", {"positions": positions})

def position_create(request):
    company_key = request.GET.get('company_key') or request.POST.get('company_key')
    company_pk = None
    if company_key:
        try:
            company_obj = Company.objects.get(company_key=company_key)
            company_pk = company_obj.pk
        except Company.DoesNotExist:
            company_pk = None

    if request.method == "POST":
        form = PositionForm(request.POST)
        if form.is_valid():
            saved = form.save()
            # after saving, return to the company form (edit) if possible
            if company_pk:
                return redirect('company_update', id=company_pk)
            # fallback to company list
            return redirect('company_list')
    else:
        # generate a new position_key (simple approach)
        # max_key = Position.objects.aggregate(Max('position_key'))['position_key__max'] or 0
        # new_key = max_key + 1
        initial = {}
        if company_key:
            initial['company_key'] = company_key
        # default dates to today for new positions
        today = timezone.now().date()
        initial['applicationdate'] = today
        initial['lastcontactdate'] = today
        initial['statusdate'] = today
        # initial['position_key'] = new_key
        form = PositionForm(initial=initial)
    return render(request, "position_form.html", {"form": form, "company_key": company_key, "company_pk": company_pk})

def position_update(request, id):
    position = get_object_or_404(Position, position_key=id)
    if request.method == "POST":
        form = PositionForm(request.POST, instance=position)
        if form.is_valid():
            form.save()
            return redirect("position_list")
    else:
        form = PositionForm(instance=position)
    return render(request, "position_form.html", {"position": position, "form": form})


def position_delete(request, id):
    position = get_object_or_404(Position, position_key=id)
    position.delete()
    return redirect("position_list")

@require_POST
def position_rejected(request, id=None):
    data = json.loads(request.body.decode()) if request.content_type == 'application/json' else request.POST
    pos_pk = id or data.get('position_key')
    # find and update Position
    pos = get_object_or_404(Position, pk=pos_pk)
    pos.status = data.get('status', 'Rejected')
    pos.statusdate = timezone.now()
    pos.lastcontactdate = timezone.now()
    pos.save()

    # create Contact linked to this Position
    Contact.objects.create(
        position_key=pos,
        contactdate=timezone.now(),
        contactmethod=data.get('contactMethod', 'email'),
        description=data.get('description', 'Rejection Received')
    )

    # re-render positions grid partial
    positions = Position.objects.filter(company_key=pos.company_key).order_by('-statusdate')
    positions_html = render_to_string('_positions_grid.html', {'positions': positions}, request=request)
    return JsonResponse({'ok': True, 'positions_html': positions_html})

@require_POST
def position_closed(request, id=None):
    data = json.loads(request.body.decode()) if request.content_type == 'application/json' else request.POST
    pos_pk = id or data.get('position_key')
    # find and update Position
    pos = get_object_or_404(Position, pk=pos_pk)
    pos.status = data.get('status', 'Closed')
    pos.statusdate = timezone.now()
    pos.lastcontactdate = timezone.now()
    pos.save()

    # create Contact linked to this Position
    Contact.objects.create(
        position_key=pos,
        contactdate=timezone.now(),
        contactmethod=data.get('contactMethod', 'email'),
        description=data.get('description', 'Position Closed')
    )

    # re-render positions grid partial
    positions = Position.objects.filter(company_key=pos.company_key).order_by('-statusdate')
    positions_html = render_to_string('_positions_grid.html', {'positions': positions}, request=request)
    return JsonResponse({'ok': True, 'positions_html': positions_html})


# @require_POST
# def position_close(request, id=None):
#     data = json.loads(request.body.decode()) if request.content_type == 'application/json' else request.POST
#     pos_pk = id or data.get('position_key')
#     # find and update Position
#     pos = get_object_or_404(Position, pk=pos_pk)
#     pos.status = data.get('status', 'Closed')
#     pos.statusdate = timezone.now()
#     pos.lastcontactdate = timezone.now()
#     pos.save()


#     # create Contact linked to this Position
#     Contact.objects.create(
#         position_key=pos,
#         contactdate=timezone.now(),
#         contactmethod=data.get('contactMethod', 'email'),
#         description=data.get('description', 'Position Closed')
#     )

    # re-render positions grid partial
    positions = Position.objects.filter(company_key=pos.company_key).order_by('-statusdate')
    positions_html = render_to_string('_positions_grid.html', {'positions': positions}, request=request)
    return JsonResponse({'ok': True, 'positions_html': positions_html})




# CRUD views for Person model


def person_list(request):
    persons = Person.objects.all()
    return render(request, "person_list.html", {"persons": persons})

def person_create(request):
    if request.method == "POST":
            Person.objects.create(
            position_key=request.POST["position_key"],
            company_key=request.POST["company_key"],
            name = request.POST["name"],
            phoneOffice=request.POST["phoneOffice"],
            phoneCell=request.POST["phoneCell"],
            preferedPhone=request.POST["preferedPhone"],
            preferedContact=request.POST["preferedContact"],
            email=request.POST["email"],
            linkedIn=request.POST["linkedIn"],
            comment=request.POST["comment"],
            )
            return redirect("person_list")
    return render(request, "person_form.html")

def person_update(request, id):
    person = get_object_or_404(Person, person_key=id)
    if request.method == "POST":
       person.position_key=request.POST["position_key"]
       person.company_key=request.POST["company_key"]
       person.name = request.POST["name"]
       person.phoneOffice=request.POST["phoneOffice"]
       person.phoneCell=request.POST["phoneCell"]
       person.preferedPhone=request.POST["preferedPhone"]
       person.preferedContact=request.POST["preferedContact"]
       person.email=request.POST["email"]
       person.linkedIn=request.POST["linkedIn"]
       person.comment=request.POST["comment"]
       person.save()
       return redirect("person_list")
    return render(request, "person_form.html", {"person": person})

def person_delete(request, id):
    person = get_object_or_404(Person, person_key=id)
    person.delete()
    return redirect("person_list")
