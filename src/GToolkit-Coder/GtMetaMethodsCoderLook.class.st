Class {
	#name : #GtMetaMethodsCoderLook,
	#superclass : #BrLook,
	#instVars : [
		'methodsCoder'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtMetaMethodsCoderLook >> addButtonElement [
	| button |
	button := BrButton new.
	button
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons add asElement;
		margin: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ];
		action: [ methodsCoder addNewCoder ].
	^ button
]

{ #category : #initialization }
GtMetaMethodsCoderLook >> classBreadcrumb [
	| breadcrumb |
	breadcrumb := BrBreadcrumb new.
	breadcrumb
		look:
			(BrGlamorousBreadcrumbLook new
				separator: [ BrLabel new
						look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
						text: '>';
						margin:
							(BlInsets
								top: 5
								left: 3
								bottom: 0
								right: 3) ]).
	methodsCoder classOrMetaClass
		withAllSuperclassesDo: [ :each | 
			| toggle |
			toggle := BrToggle new
				activated: (methodsCoder filteredClass: each);
				label: (each name asRopedText attributes: {(BlFontSizeAttribute size: 12)});
				look: BrMaterialToggleWithLabelLook;
				when: BrToggleActivatedEvent do: [ :anEvent | methodsCoder addMethodsForClass: each ];
				when: BrToggleDeactivatedEvent do: [ :anEvent | methodsCoder removeMethodsForClass: each ].
			breadcrumb addItem: toggle ].
	^ breadcrumb
]

{ #category : #initialization }
GtMetaMethodsCoderLook >> headerElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element padding: (BlInsets all: 10).
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
