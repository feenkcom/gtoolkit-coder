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
	{methodCoder classOrMetaClass package name.
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
	self addChild: self breadcrumb.
	self addChild: self editorElement as: #bodyElement.
	self actionsElement ifNotNil: [ :el | self addChild: el ]
]
