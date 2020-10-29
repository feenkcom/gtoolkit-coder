"
!Source coder breadcrumb
${example:GtSourceCoderBreadcrumbElementExamples>>#breadcrumbForSourceCoder}$
"
Class {
	#name : #GtSourceCoderBreadcrumbElement,
	#superclass : #BrBreadcrumb,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #accessing }
GtSourceCoderBreadcrumbElement >> coder: aCoder [
	self 
		deprecated: 'Use #sourceCoderUIModel: instead.'
		transformWith: '`@receiver coder: `@arg' -> '`@receiver sourceCoderUIModel: `@arg'.
		
	self sourceCoderUIModel: aCoder
]

{ #category : #initialization }
GtSourceCoderBreadcrumbElement >> initialize [
	super initialize.
	
	self look: (BrGlamorousBreadcrumbLook new
		separator: [ BrLabel new
			look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
			text: '>';
			margin: (BlInsets left: 5 right: 5) ]).
	
	self 
		fitContent
]

{ #category : #'instance creation' }
GtSourceCoderBreadcrumbElement >> newBreadcrumbItemElementsFor: aSourceCoder [
	<return: #Collection of: #BrButton>

	^ aSourceCoder breadcrumbActions
		collect: [ :eachBreadcrumbAction | self newBreadcrumbItemFor: eachBreadcrumbAction ]
]

{ #category : #'instance creation' }
GtSourceCoderBreadcrumbElement >> newBreadcrumbItemFor: aGtSourceCoderBreadcrumbAction [
	^ BrButton new
		look: (BrGlamorousLabelLook new
			foreground: BrGlamorousColors defaultButtonTextColor;
			fontSize: 12);
		label: aGtSourceCoderBreadcrumbAction name;
		model: aGtSourceCoderBreadcrumbAction;
		action: [ :aButtonElement :aButtonModel | aButtonModel model performSourceCoderActionFrom: aButtonElement ]
]

{ #category : #accessing }
GtSourceCoderBreadcrumbElement >> sourceCoderUIModel: aGtSourceCoderUIModel [
	self removeAllItems.
	self addItems: (self newBreadcrumbItemElementsFor: aGtSourceCoderUIModel coder)
]
