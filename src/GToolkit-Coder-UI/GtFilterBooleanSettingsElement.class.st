Class {
	#name : #GtFilterBooleanSettingsElement,
	#superclass : #GtFilterSettingsElement,
	#instVars : [
		'switcherElement'
	],
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterBooleanSettingsElement >> initialize [
	super initialize.
	self initializeSwitcherElement.
	self addChild: switcherElement as: #switcher
]

{ #category : #initialization }
GtFilterBooleanSettingsElement >> initializeSwitcherElement [
	switcherElement := BrCheckbox new
		fitContent;
		aptitude: BrGlamorousCheckboxAptitude;
		whenCheckedDo: [ :anEvent | self onCheckedEvent: anEvent ];
		whenUncheckedDo: [ :anEvent | self onUncheckedEvent: anEvent ].
]

{ #category : #'event handling' }
GtFilterBooleanSettingsElement >> onCheckedEvent: anEvent [ 
]

{ #category : #'as yet unclassified' }
GtFilterBooleanSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.

	self updateSwitcherElement
]

{ #category : #'event handling' }
GtFilterBooleanSettingsElement >> onSwitchChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateSwitcherElement ]
]

{ #category : #'event handling' }
GtFilterBooleanSettingsElement >> onUncheckedEvent: anEvent [ 
]

{ #category : #'api - filter view model' }
GtFilterBooleanSettingsElement >> subscribeToFilterViewModel [
	super subscribeToFilterViewModel.

	self filterViewModel weak
		when: GtFilterBooleanViewModelSwitchChanged
		send: #onSwitchChanged:
		to: self
]

{ #category : #'private - updating' }
GtFilterBooleanSettingsElement >> updateSwitcherElement [
	switcherElement checked: self filterViewModel isSwitchedOn
]
