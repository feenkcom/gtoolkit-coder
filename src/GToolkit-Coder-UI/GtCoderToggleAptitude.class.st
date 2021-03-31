Class {
	#name : #GtCoderToggleAptitude,
	#superclass : #BrMaterialToggleBackgroundAptitude,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderToggleAptitude >> defaultNormalBackground [
	^ Color transparent
]

{ #category : #initialization }
GtCoderToggleAptitude >> initialize [
	| interactiveLook |
	super initialize.
	self flag: 'Working around a toggled display issue'.
	interactiveLook := self looks
		detect: [ :each | each isKindOf: BrInteractiveAptitude ]
		ifNone: [ nil ].
	interactiveLook notNil
		ifTrue: [ interactiveLook
				style: [ :aStyler | 
					aStyler default: [ :aWidget | self updateActivatedBackground ].
					aStyler
						pressed:
							[ :aWidget | aWidget background: self defaultCheckedBackground slightlyLighter ] ] ].
	self
		add: BrMaterialRoundedAptitude new;
		add: BrTextLabelAptitude new.
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
GtCoderToggleAptitude >> updateActivatedBackground [
	self widget isActivated
		ifTrue: [ self toggleActivated ]
		ifFalse: [ self toggleDeactivated ]
]
