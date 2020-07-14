Class {
	#name : #GtCoderBreadcrumbElement,
	#superclass : #BrBreadcrumb,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderBreadcrumbElement >> coder: aCoder [
	self removeAllItems.
	self addItems: (self newBreadcrumbItemElementsFor: aCoder)
]

{ #category : #initialization }
GtCoderBreadcrumbElement >> initialize [
	super initialize.
	
	self look: (BrGlamorousBreadcrumbLook new
		separator: [ BrLabel new
			look: (BrGlamorousLabelLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
			text: '>';
			margin: (BlInsets left: 5 right: 5) ]).
	
	self 
		fitContent;
		background: Color transparent
]

{ #category : #'instance creation' }
GtCoderBreadcrumbElement >> newBreadcrumbItemElementsFor: aCoder [
	<return: #Collection of: #BrButton>

	^ aCoder breadcrumbNamedActions
		collect: [ :eachNamedAction | 
			BrButton new
				look:
					(BrGlamorousLabelLook new
						foreground: BrGlamorousColors defaultButtonTextColor;
						fontSize: 12);
				label: eachNamedAction key;
				action: eachNamedAction value ]
]
