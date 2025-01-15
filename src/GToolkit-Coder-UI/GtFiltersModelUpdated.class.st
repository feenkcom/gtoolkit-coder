"
I announce that a {{gtClass:GtFiltersModel}} changed. 
I am announced only if an update changes search filter results. 
In other words, I must not be announced if an added or removed filter model does not have a selected value.
"
Class {
	#name : #GtFiltersModelUpdated,
	#superclass : #GtFiltersModelAnnouncement,
	#category : #'GToolkit-Coder-UI-Filters - Events'
}
