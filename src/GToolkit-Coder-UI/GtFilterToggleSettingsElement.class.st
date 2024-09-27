Class {
	#name : #GtFilterToggleSettingsElement,
	#superclass : #GtFilterSettingsElement,
	#instVars : [
		'toggleGroupElement'
	],
	#category : #'GToolkit-Coder-UI-Filters - Widgets'
}

{ #category : #initialization }
GtFilterToggleSettingsElement >> initialize [
	super initialize.
	self initializeToggleGroupElement.

	self addChild: toggleGroupElement as: #toggles
]

{ #category : #initialization }
GtFilterToggleSettingsElement >> initializeToggleGroupElement [
	toggleGroupElement := BrToggleGroup new
			aptitude: BrGlamorousToggleGroupAptitude new;
			when: BrToggleActivatedEvent
				do: [ :anEvent | self onToggleActivatedEvent: anEvent ]
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> newAptitudeForItem: anItem [
	| anAptitude |
	anAptitude := anItem
			ifIconAndLabel: [ BrGlamorousToggleWithIconAndLabelAptitude new ]
			ifIcon: [ BrGlamorousToggleWithIconAptitude new ]
			ifLabel: [ BrGlamorousToggleWithLabelAptitude new ].
			
	"anAptitude - BrGlamorousToggleBackgroundAptitude.
	anAptitude add: (BrToggleAptitude new
		activated: [ :aStyle | aStyle visibility: BlVisibility visible ];
		default: [ :aStyle | aStyle visibility: BlVisibility hidden ])"
		
	^ anAptitude
]

{ #category : #'api - filter view model' }
GtFilterToggleSettingsElement >> onFilterViewModelChanged [
	super onFilterViewModelChanged.
	self updateElement
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onItemsChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateElement ]
]

{ #category : #'event handling' }
GtFilterToggleSettingsElement >> onSelectedItemChanged: anAnnouncement [
	BlTaskAction enqueueElement: self action: [ self updateActiveToggle ]
]

{ #category : #initialization }
GtFilterToggleSettingsElement >> onToggleActivatedEvent: anEvent [ 
	self hasFilterViewModel ifFalse: [ ^ self ].
	anEvent toggle model ifNotNil: [ :anItem | 
		self filterViewModel selectedItem: anItem ]
]

{ #category : #'api - filter view model' }
GtFilterToggleSettingsElement >> subscribeToFilterViewModel [
	super subscribeToFilterViewModel.
	self filterViewModel weak
		when: GtFilterViewModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFilterViewModelSelectedItemChanged
			send: #onSelectedItemChanged:
			to: self
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> updateActiveToggle [
	| aSelectedItem |
	aSelectedItem := self filterViewModel selectedItem.
	toggleGroupElement activatedToggle viewModel model == aSelectedItem
		ifTrue: [ ^ self ].
	toggleGroupElement viewModel toggles
		do: [ :eachToggle | 
			eachToggle viewModel model == aSelectedItem 
				ifTrue: [ eachToggle activate ] ]
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> updateElement [
	self updateToggles
]

{ #category : #'private - updating' }
GtFilterToggleSettingsElement >> updateToggles [
	| aSelectedItem |
	toggleGroupElement removeToggles.
	aSelectedItem := self filterViewModel selectedItem.

	self filterViewModel items
		do: [ :eachItem | 
			| aToggle |
			aToggle := BrToggle new.
			aToggle beSmallSize.
			aToggle viewModel model: eachItem.
			eachItem == aSelectedItem ifTrue: [ aToggle activate ].
			eachItem ifIcon: [ :anIcon | aToggle icon: anIcon ].
			eachItem ifLabel: [ :aLabel | aToggle label: aLabel ].
			aToggle aptitude: (self newAptitudeForItem: eachItem).
			toggleGroupElement addToggle: aToggle ]
]
