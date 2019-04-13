Class {
	#name : #GtClassMethodsCoderElement,
	#superclass : #GtFilteredMethodsCoderElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #ui }
GtClassMethodsCoderElement >> addButtonElement [
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

{ #category : #'private - callbacks' }
GtClassMethodsCoderElement >> addClassToFilter: aBehavior [
	methodsCoder addMethodsForClass: aBehavior
]

{ #category : #ui }
GtClassMethodsCoderElement >> buildElement [
	super buildElement.
	self addChild: self headerElement at: 1
]

{ #category : #ui }
GtClassMethodsCoderElement >> classBreadcrumb [
	| breadcrumb scrollable |
	breadcrumb := BrBreadcrumb new.
	breadcrumb look: self classBreadcrumbLook.
	methodsCoder classOrMetaClass withAllSuperclassesDo: [ :each | 
		| toggle |
		toggle := (self classBreadcrumbElementForClass: each)
			when: BrToggleActivatedEvent do: [ :anEvent | self addClassToFilter: each ];
			when: BrToggleDeactivatedEvent	do: [ :anEvent | 
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
GtClassMethodsCoderElement >> classBreadcrumbElementForClass: aClass [
	^ BrToggle new
		margin: (BlInsets all: 2);
		activated: (methodsCoder filteredClass: aClass);
		label: (aClass name asRopedText attributes: {(BlFontSizeAttribute size: 12)});
		look: GtClassBreadcrumbToggleLook
]

{ #category : #ui }
GtClassMethodsCoderElement >> classBreadcrumbLook [
	^ (BrGlamorousBreadcrumbLook new
			separator: [ BrLabel new
				look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
				text: '>';
				margin: (BlInsets top: 6 left: 3 bottom: 0 right: 3) ])
]

{ #category : #ui }
GtClassMethodsCoderElement >> headerElement [
	| element |
	element := BlElement new.
	element clipChildren: false.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets top: 10);
		addChildren: {
			self classBreadcrumb. 
			self addButtonElement }.
	^ element
]

{ #category : #'private - callbacks' }
GtClassMethodsCoderElement >> removeClassFromFilter: aBehavior ifEmpty: aBlock [
	methodsCoder removeMethodsForClass: aBehavior.
	methodsCoder hasFilter
		ifFalse: aBlock
]
