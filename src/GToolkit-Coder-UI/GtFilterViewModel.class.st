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

{ #category : #accessing }
GtFilterViewModel >> label [
	<return: #String>
	^ self filterModel label
]

{ #category : #'event handling' }
GtFilterViewModel >> onLabelChanged: anAnnouncement [
	self
		announce: (GtFilterViewModelLabelChanged new
				viewModel: self;
				label: anAnnouncement label)
]

{ #category : #printing }
GtFilterViewModel >> printOn: aStream [
	super printOn: aStream.

	self hasFilterModel ifFalse: [ ^ self ].
	aStream nextPut: $(.
	self filterModel printDetailsOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
GtFilterViewModel >> selectedValue [
	^ self filterModel selectedValue
]

{ #category : #'api - filter model' }
GtFilterViewModel >> subscribeToFilterModel [
	self filterModel weak
		when: GtFilterModelLabelChanged
		send: #onLabelChanged:
		to: self
]

{ #category : #'api - filter model' }
GtFilterViewModel >> unsubscribeFromFilterModel [
	self filterModel unsubscribe: self
]
