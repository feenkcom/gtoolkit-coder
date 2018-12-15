Class {
	#name : #GtMetaMethodsCoderLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #ui }
GtMetaMethodsCoderLook >> addButtonElement [
	| button |
	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons add asElement;
		margin: (BlInsets all: 8);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ];
		action: [ methodsCoder addNewCoder ].
	^ button
]

{ #category : #private }
GtMetaMethodsCoderLook >> addClassToFilter: aBehavior [
	methodsCoder addMethodsForClass: aBehavior
]

{ #category : #ui }
GtMetaMethodsCoderLook >> classBreadcrumb [
	| breadcrumb scrollable |
	breadcrumb := BrBreadcrumb new.
	breadcrumb
		look:
			(BrGlamorousBreadcrumbLook new
				separator: [ BrLabel new
						look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
						text: '>';
						margin:
							(BlInsets
								top: 6
								left: 3
								bottom: 0
								right: 3) ]).
	methodsCoder classOrMetaClass
		withAllSuperclassesDo: [ :each | 
			| toggle |
			toggle := BrToggle new
				margin: (BlInsets all: 2);
				activated: (methodsCoder filteredClass: each);
				label: (each name asRopedText attributes: {(BlFontSizeAttribute size: 12)});
				look: GtClassBreadcrumbToggleLook;
				when: BrToggleActivatedEvent do: [ :anEvent | self addClassToFilter: each ];
				when: BrToggleDeactivatedEvent
					do: [ :anEvent | 
					self
						removeClassFromFilter: each
						ifEmpty: [ each == methodsCoder classOrMetaClass
								ifTrue: [ anEvent consumed: true ].
							(breadcrumb itemAt: 1) activate ] ].
			breadcrumb addItem: toggle ].
	scrollable := breadcrumb asScrollableElement.
	scrollable margin: (BlInsets right: 40).
	^ scrollable
]

{ #category : #ui }
GtMetaMethodsCoderLook >> headerElement [
	| element |
	element := BlElement new.
	element clipChildren: false.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		padding:
			(BlInsets
				top: 10
				left: 10
				bottom: 0
				right: 10).
	element addChild: self classBreadcrumb.
	element addChild: self addButtonElement.
	^ element
]

{ #category : #initialization }
GtMetaMethodsCoderLook >> initializeLook [
	super initializeLook.
	self widget addChild: self headerElement at: 1
]

{ #category : #accessing }
GtMetaMethodsCoderLook >> methodsCoder [
	^ methodsCoder
]

{ #category : #accessing }
GtMetaMethodsCoderLook >> methodsCoder: aMethodsCoder [
	methodsCoder := aMethodsCoder
]

{ #category : #private }
GtMetaMethodsCoderLook >> removeClassFromFilter: aBehavior ifEmpty: aBlock [
	methodsCoder removeMethodsForClass: aBehavior.
	methodsCoder hasFilter
		ifFalse: aBlock
]
