Class {
	#name : #GtCoderToggleLook,
	#superclass : #BrMaterialToggleBackgroundLook,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderToggleLook >> defaultNormalBackground [
	^ Color transparent
]

{ #category : #initialization }
GtCoderToggleLook >> initialize [
	| interactiveLook |
	super initialize.
	self flag: 'Working around a toggled display issue'.
	interactiveLook := self looks
		detect: [ :each | each isKindOf: BrInteractiveLook ]
		ifNone: [ nil ].
	interactiveLook notNil
		ifTrue: [ interactiveLook
				style: [ :aStyler | 
					aStyler default: [ :aWidget | self updateActivatedBackground ].
					aStyler
						pressed:
							[ :aWidget | aWidget background: self defaultCheckedBackground slightlyLighter ] ] ].
	self
		add: BrMaterialRoundedLook new;
		add: BrTextLabelLook new.
	self
		addChange:
			(BrLookChange new
				up: [ :e | 
					self flag: 'Working around a toggled display issue'.
					self updateActivatedBackground ];
				down: [ :e |  ];
				yourself)
]

{ #category : #private }
GtCoderToggleLook >> updateActivatedBackground [
	self widget isActivated
		ifTrue: [ self toggleActivated ]
		ifFalse: [ self toggleDeactivated ]
]
