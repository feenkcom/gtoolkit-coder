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
GtCoderMethodSourceElement >> createBreadcrumbItemsFor: aMethodCoder [
	<return: #Collection of: #BrButton>
	| theNamedActions |

	"Array (name -> action)"
	theNamedActions := Array streamContents: [ :aStream | 
		| aPackage aPackageName aClass |
		aPackage := (methodCoder compiledMethod ifNil: [ methodCoder classOrMetaClass ]) package.
		aPackageName := aPackage ifNil: [ '' ] ifNotNil: #name.
		aClass := methodCoder classOrMetaClass.

		aStream
			nextPut: (aPackageName -> [ :aButton | aButton phlow spawnObject: aPackage ]);
			nextPut: (aClass name -> [ :aButton | aButton phlow spawnObject: (GtClassCoder forClass: aClass) ]) ].
		
	^ theNamedActions collect: [ :eachNamedAction |
		BrButton new
			look: (BrGlamorousLabelLook new
				foreground: BrGlamorousColors defaultButtonTextColor;
				fontSize: 12);
			label: eachNamedAction key;
			action: eachNamedAction value ]
]

{ #category : #accessing }
GtCoderMethodSourceElement >> editorElement [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
GtCoderMethodSourceElement >> initialize [
	super initialize.
	self layout: BlLinearLayout vertical.
	
	self addChild: self newHeaderElement as: #header
]

{ #category : #accessing }
GtCoderMethodSourceElement >> methodCoder [
	<return: #GtMethodCoder>

	^ methodCoder
]

{ #category : #accessing }
GtCoderMethodSourceElement >> methodCoder: aMethodCoder [
	methodCoder := aMethodCoder.
	
	self addChild: self editorElement as: #bodyElement.
	self actionsElement ifNotNil: [ :el | self addChild: el ].
	
	self setBreadcrumbItems: (self childNamed: #breadcrumb) coder: aMethodCoder
]

{ #category : #accessing }
GtCoderMethodSourceElement >> methodCoderDo: aBlock [
	methodCoder ifNotNil: aBlock
]

{ #category : #'instance creation' }
GtCoderMethodSourceElement >> newBreadcrumb [
	<return: #BrBreadcrumb>

	| aBreadcrumb |
	aBreadcrumb := BrBreadcrumb new.
	aBreadcrumb
		look: self newBreadcrumbLook;
		constraintsDo: [ :c |
			c margin: (BlInsets top: 2).
			c frame horizontal alignLeft.
			c frame vertical alignCenter ].
		
	self methodCoderDo: [ :aMethodCoder | self setBreadcrumbItems: aBreadcrumb coder: aMethodCoder ].

	^ aBreadcrumb
]

{ #category : #'instance creation' }
GtCoderMethodSourceElement >> newBreadcrumbLook [
	^ BrGlamorousBreadcrumbLook new
		separator: [ BrLabel new
			look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
			text: '>';
			margin: (BlInsets left: 5 right: 5) ]
]

{ #category : #'instance creation' }
GtCoderMethodSourceElement >> newHeaderElement [
	| aHeaderElement |

	aHeaderElement := BlElement new.
	aHeaderElement clipChildren: false.
	aHeaderElement layout: BlFrameLayout new.
	aHeaderElement
		constraintsDo: [ :c |
			c padding: BlInsets empty.
			c horizontal matchParent.
			c vertical fitContent ].
	aHeaderElement addChild: self newBreadcrumb as: #breadcrumb.

	^ aHeaderElement
]

{ #category : #private }
GtCoderMethodSourceElement >> setBreadcrumbItems: aBreadcrumb coder: aMethodCoder [
	"Initialize breadcrumb items for a given coder"

	aBreadcrumb removeAllItems.
	aBreadcrumb addItems: (self createBreadcrumbItemsFor: aMethodCoder)
]
