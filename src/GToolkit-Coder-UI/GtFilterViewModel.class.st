Class {
	#name : #GtFilterViewModel,
	#superclass : #Object,
	#traits : 'TGtWithFilterModel + TGtAnnouncer',
	#classTraits : 'TGtWithFilterModel classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #announcer }
GtFilterViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtFilterViewModel >> asUserSettingsElement [
	<return: #GtFilterSettingsElement>
	^ self filterElementClass new filterViewModel: self
]

{ #category : #accessing }
GtFilterViewModel >> filterElementClass [
	<return: #'GtFilterSettingsElement class'>
	^ self subclassResponsibility
]
