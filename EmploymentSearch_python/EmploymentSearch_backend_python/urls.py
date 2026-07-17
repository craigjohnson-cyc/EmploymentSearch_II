"""
Definition of urls for EmploymentSearch_backend_python.
"""

from datetime import datetime
from django.urls import path
from django.contrib import admin
from django.contrib.auth.views import LoginView, LogoutView
from app import forms, views


urlpatterns = [
    path('', views.home, name='home'),
    path('contact/', views.contact, name='contact'),
    path('about/', views.about, name='about'),
    path('login/',
         LoginView.as_view
         (
             template_name='app/login.html',
             authentication_form=forms.BootstrapAuthenticationForm,
             extra_context=
             {
                 'title': 'Log in',
                 'year' : datetime.now().year,
             }
         ),
         name='login'),
    path('logout/', LogoutView.as_view(next_page='/'), name='logout'),
    path('admin/', admin.site.urls),

    path("company/", views.company_list, name="company_list"),
    path("company/search/", views.company_search, name="company_search"),
    path("company/create/", views.company_create, name="company_create"),
    path("company/update/<int:id>/", views.company_update, name="company_update"),
    path("company/delete/<int:id>/", views.company_delete, name="company_delete"),

    path("contacts/", views.contact_list, name="contact_list"),
    path("contacts/create/", views.contact_create, name="contact_create"),
    path("contacts/update/<int:id>/", views.contact_update, name="contact_update"),
    path("contacts/delete/<int:id>/", views.contact_delete, name="contact_delete"),

    path("positions/", views.position_list, name="position_list"),
    path("positions/create/", views.position_create, name="position_create"),
    path("positions/update/<int:id>/", views.position_update, name="position_update"),
    path("positions/delete/<int:id>/", views.position_delete, name="position_delete"),
    path("positions/reject/<int:id>/", views.position_rejected, name="position_rejected"),
    path("positions/close/<int:id>/", views.position_closed,   name="position_closed"),

    path("persons/", views.person_list, name="person_list"),
    path("persons/create/", views.person_create, name="person_create"),
    path("persons/update/<int:id>/", views.person_update, name="person_update"),
    path("persons/delete/<int:id>/", views.person_delete, name="person_delete"),

]
