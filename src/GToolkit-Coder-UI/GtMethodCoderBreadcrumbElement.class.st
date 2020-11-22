"
!Source coder breadcrumb
${example:GtMethodCoderBreadcrumbElementExamples>>#breadcrumbForSourceCoder}$
"
Class {
	#name : #GtMethodCoderBreadcrumbElement,
	#superclass : #BrBreadcrumb,
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #accessing }
GtMethodCoderBreadcrumbElement >> coder: aCoder [
	self 
		deprecated: 'Use #sourceCoderUIModel: instead.'
		transformWith: '`@receiver coder: `@arg' -> '`@receiver sourceCoderUIModel: `@arg'.
		
	self sourceCoderUIModel: aCoder
]

{ #category : #initialization }
GtMethodCoderBreadcrumbElement >> initialize [
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
GtMethodCoderBreadcrumbElement >> newBreadcrumbItemElementsFor: aSourceCoder [
	<return: #Collection of: #BrButton>

	^ aSourceCoder breadcrumbActions
		collect: [ :eachBreadcrumbAction | self newBreadcrumbItemFor: eachBreadcrumbAction ]
]

{ #category : #'instance creation' }
GtMethodCoderBreadcrumbElement >> newBreadcrumbItemFor: aGtSourceCoderBreadcrumbAction [
	^ BrButton new
		look: (BrGlamorousLabelLook new
			foreground: aGtSourceCoderBreadcrumbAction foreground;
			fontSize: 12);
		label: aGtSourceCoderBreadcrumbAction name;
		model: aGtSourceCoderBreadcrumbAction;
		action: [ :aButtonElement :aButtonModel | aButtonModel model performSourceCoderActionFrom: aButtonElement ]
]

{ #category : #'event handling' }
GtMethodCoderBreadcrumbElement >> onCoderClassChanged: anAnnouncement [
	| aCoder |
	
	aCoder := anAnnouncement coder.
	self enqueueTask: (BlTaskAction new action: [ self updateBreadcrumbElements: aCoder ])
]

{ #category : #'event handling' }
GtMethodCoderBreadcrumbElement >> onCoderMethodModified: anAnnouncement [
	anAnnouncement coder isModified
		ifTrue: [ self background: BrGlamorousColors errorBackgroundColor ]
		ifFalse: [ self background: Color white ]
]

{ #category : #'event handling' }
GtMethodCoderBreadcrumbElement >> onCoderSourceTextModified: anAnnouncement [
	anAnnouncement coder isModified
		ifTrue: [ self background: BrGlamorousColors failureBackgroundColor ]
		ifFalse: [ self background: Color white ]
]

{ #category : #accessing }
GtMethodCoderBreadcrumbElement >> sourceCoderUIModel: aGtSourceCoderUIModel [
	self updateBreadcrumbElements: aGtSourceCoderUIModel coder.
	
	 aGtSourceCoderUIModel coder weak
		when: GtCoderClassAdded, GtCoderClassRenamed, GtCoderClassRemoved
		send: #onCoderClassChanged:
		to: self.

	aGtSourceCoderUIModel coder weak
		when: GtCoderMethodModified
		send: #onCoderMethodModified:
		to: self.
		
	aGtSourceCoderUIModel coder weak
		when: GtCoderSourceCodeChanged
		send: #onCoderSourceTextModified:
		to: self.
		
	
]

{ #category : #accessing }
GtMethodCoderBreadcrumbElement >> updateBreadcrumbElements: aMethodCoder [
	self removeAllItems.
	self addItems: (self newBreadcrumbItemElementsFor: aMethodCoder)
]
