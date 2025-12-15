Class {
	#name : #GtFilterBooleanViewModel,
	#superclass : #GtFilterViewModel,
	#category : 'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterBooleanViewModel >> filterElementClass [
	^ GtFilterBooleanSettingsElement
]

{ #category : #testing }
GtFilterBooleanViewModel >> isSwitchedOff [
	^ self filterModel isSwitchedOff
]

{ #category : #testing }
GtFilterBooleanViewModel >> isSwitchedOn [
	^ self filterModel isSwitchedOn
]

{ #category : #'event handling' }
GtFilterBooleanViewModel >> onSwitchChanged: anAnnouncement [
	self announce: (GtFilterBooleanViewModelSwitchChanged new viewModel: self)
]

{ #category : #'api - filter model' }
GtFilterBooleanViewModel >> subscribeToFilterModel [
	super subscribeToFilterModel.
	self filterModel weak
		when: GtFilterBooleanModelSwitchChanged
		send: #onSwitchChanged:
		to: self
]
