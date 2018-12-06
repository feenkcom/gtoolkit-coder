Class {
	#name : #GtClassBreadcrumbToggleLook,
	#superclass : #BrMaterialToggleBackgroundLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtClassBreadcrumbToggleLook >> defaultNormalBackground [
	^ Color transparent
]

{ #category : #initialization }
GtClassBreadcrumbToggleLook >> initialize [
	| interactiveLook |
	super initialize.
	
	self flag: 'Working around a toggled display issue'.
	interactiveLook := self looks detect: [ :each | each isKindOf: BrInteractiveLook ] ifNone: [ nil ].
	interactiveLook notNil
		ifTrue: [ interactiveLook
				style: [ :aStyler | 
					aStyler default: [ :aWidget | self updateActivatedBackground ].
					aStyler pressed: [ :aWidget | aWidget background: self defaultCheckedBackground slightlyLighter ] ] ].

	self
		add: BrMaterialRoundedLook new;
		add: BrTextLabelLook new
]

{ #category : #initialization }
GtClassBreadcrumbToggleLook >> initializeLook [
	super initializeLook.
	
	self flag: 'Working around a toggled display issue'.
	self updateActivatedBackground
	
	widget layout: BlLinearLayout horizontal alignCenter.
	widget constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical exact: 16.
		c padding: (BlInsets all: 6) ]
]

{ #category : #private }
GtClassBreadcrumbToggleLook >> updateActivatedBackground [
	self widget isActivated
		ifTrue: [ self toggleActivated ]
		ifFalse: [ self toggleDeactivated ]
]
