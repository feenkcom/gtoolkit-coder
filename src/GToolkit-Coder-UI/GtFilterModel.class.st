Class {
	#name : #GtFilterModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #announcer }
GtFilterModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtFilterModel >> asFilterViewModel [
	<return: #GtFilterViewModel>
	^ self filterViewModelClass new filterModel: self
]

{ #category : #converting }
GtFilterModel >> asUserSettingsElement [
	<return: #GtFilterSettingsElement>
	^ self asFilterViewModel asUserSettingsElement
]

{ #category : #accessing }
GtFilterModel >> filterViewModelClass [
	<return: #'GtFilterViewModel class'>
	^ self subclassResponsibility
]
