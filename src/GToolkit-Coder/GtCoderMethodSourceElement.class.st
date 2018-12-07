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

{ #category : #accessing }
GtCoderMethodSourceElement >> breadcrumb [
	| breadcrumb |
	breadcrumb := BrBreadcrumb new.
	breadcrumb
		look:
			(BrGlamorousBreadcrumbLook new
				separator: [ BrLabel new
						look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
						text: '>';
						margin: (BlInsets left: 5 right: 5) ]).
	{(methodCoder compiledMethod ifNil: [ methodCoder classOrMetaClass ]) package name.
	methodCoder classOrMetaClass name}
		do: [ :aLocationStepName | 
			breadcrumb
				addItem:
					(BrLabel new
						look:
							(BrGlamorousLabelLook new
								foreground: BrGlamorousColors defaultButtonTextColor;
								fontSize: 12);
						text: aLocationStepName) ].
	^ breadcrumb
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
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element padding: (BlInsets all: 0).
	element addChild: self breadcrumb as: #breadcrumb.
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
