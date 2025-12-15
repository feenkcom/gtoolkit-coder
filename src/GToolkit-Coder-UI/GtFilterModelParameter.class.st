Class {
	#name : #GtFilterModelParameter,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'updater',
		'announcer'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #announcer }
GtFilterModelParameter >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtFilterModelParameter >> asFilterViewModel [
	<return: #GtFilterViewModel>
	^ self filterViewModelClass new filterModel: self
]

{ #category : #converting }
GtFilterModelParameter >> asUserParametersElement [
	<return: #GtFilterSettingsElement>
	^ self asFilterViewModel asUserParametersElement
]

{ #category : #testing }
GtFilterModelParameter >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	<return: #Boolean>
	^ false
]

{ #category : #accessing }
GtFilterModelParameter >> filterViewModelClass [
	^ self subclassResponsibility
]

{ #category : #'gt - extensions' }
GtFilterModelParameter >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		stencil: [ self asUserParametersElement margin: (BlInsets all: 10) ]
]

{ #category : #converting }
GtFilterModelParameter >> onCreateFilter: aFilter [
	updater ifNil: [ ^ self ].
	updater cull: aFilter cull: self selectedValue cull: self.
]

{ #category : #printing }
GtFilterModelParameter >> printDetailsOn: aStream [
	aStream
		print: (self selectedValue ifNotNil: [ :aValue | aValue asFilterModelItem itemValue ])
]

{ #category : #accessing }
GtFilterModelParameter >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ nil
]

{ #category : #accessing }
GtFilterModelParameter >> updater [
	^ updater
]

{ #category : #accessing }
GtFilterModelParameter >> updater: aBlock [
	
	updater := aBlock
]
