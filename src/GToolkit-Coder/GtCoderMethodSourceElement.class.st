Class {
	#name : #GtCoderMethodSourceElement,
	#superclass : #BlElement,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderMethodSourceElement >> actionsElement [
	^ nil
]

{ #category : #private }
GtCoderMethodSourceElement >> addLocationStepName: aLocationStepName action: aBlock to: aBrBreadcrumb [
	^ aBrBreadcrumb
		addItem:
			(BrButton new
				look:
					(BrGlamorousLabelLook new
						foreground: BrGlamorousColors defaultButtonTextColor;
						fontSize: 12);
				label: aLocationStepName asRopedText;
				action: (aBlock ifNil: [ [ "do nothing" ] ]) )
]

{ #category : #accessing }
GtCoderMethodSourceElement >> editorElement [
	self subclassResponsibility
]

{ #category : #accessing }
GtCoderMethodSourceElement >> headerElement [
	| element |
	element := BlElement new.
	element clipChildren: false.
	element layout: BlFrameLayout new.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element padding: (BlInsets all: 0).
	element addChild: self newBreadcrumb as: #breadcrumb.
	^ element
]

{ #category : #'initialize-release' }
GtCoderMethodSourceElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical
]

{ #category : #accessing }
GtCoderMethodSourceElement >> methodCoder [
	<return: #GtMethodCoder>

	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodSourceElement >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder.
	self addChild: self headerElement as: #header.
	self addChild: self editorElement as: #bodyElement.
	self actionsElement ifNotNil: [ :el | self addChild: el ]
]

{ #category : #'instance creation' }
GtCoderMethodSourceElement >> newBreadcrumb [
	| aBrBreadcrumb aPackageName aClassName aPackage |
	aBrBreadcrumb := BrBreadcrumb new.
	aBrBreadcrumb
		look: self newBreadcrumbLook;
		constraintsDo: [ :c | 
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ].
	aPackage := (methodCoder compiledMethod
		ifNil: [ methodCoder classOrMetaClass ]) package.
	aPackageName := aPackage
		ifNil: [ '' ]
		ifNotNil: [ :package | package name ].
	self addLocationStepName: aPackageName 
		action: [ :aButton | aButton phlow spawnObject: aPackage ] 
		to: aBrBreadcrumb.
	aClassName := methodCoder classOrMetaClass name.
	self
		addLocationStepName: aClassName
		action: [ :aButton | 
			aButton phlow
				spawnObject: (GtClassCoder forClass: methodCoder classOrMetaClass) ]
		to: aBrBreadcrumb.
	^ aBrBreadcrumb
]

{ #category : #'instance creation' }
GtCoderMethodSourceElement >> newBreadcrumbLook [
	^ BrGlamorousBreadcrumbLook new
		separator: [ BrLabel new
				look:
					(BrGlamorousLabelLook new thin
						foreground: BrGlamorousColors defaultButtonTextColor);
				text: '>';
				margin: (BlInsets left: 5 right: 5) ]
]
