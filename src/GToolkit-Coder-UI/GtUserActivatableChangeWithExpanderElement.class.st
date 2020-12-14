Class {
	#name : #GtUserActivatableChangeWithExpanderElement,
	#superclass : #GtUserActivatableChangeElement,
	#instVars : [
		'expander',
		'header',
		'description',
		'checkbox'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
}

{ #category : #'instance creation' }
GtUserActivatableChangeWithExpanderElement >> activatableChange: aGtUserActivatableChange [

	activatableChange ifNotNil: [ activatableChange announcer unsubscribe: self ].
	activatableChange := aGtUserActivatableChange.
	activatableChange announcer weak
		when: #enablementChanged send: #onEnablementChanged to: self.

	activatableChange isEnabled
		ifTrue: [ checkbox check ]
		ifFalse: [ checkbox uncheck ].

	description text: activatableChange change displayString. 

	expander content: [
		((activatableChange hasDiff)
			ifTrue: [
				(GtDiffElement on: activatableChange change gtDiff)
					look: GtDiffFlatLook;
					vFitContent;
					beSmallSize ]
			ifFalse: [
				BrLabel new
					beSmallSize;
					look: BrGlamorousLabelLook new;
					text: activatableChange change displayString ]) ].
			
	activatableChange isExpanded
		ifTrue: [ expander expand ]
		ifFalse: [ expander collapse ].
]

{ #category : #initialization }
GtUserActivatableChangeWithExpanderElement >> initialize [
	super initialize.
	
	expander := BrExpander new.
	expander
		look: (GtCoderExpanderLook new
			cornerRadius: 3;
			padding: (BlInsets empty);
			doNotReplaceHeader) + (BrStyleCommonLook new
				expanded: [ :aStyle |
					aStyle margin: (BlInsets top: 5 left: 5 bottom: 5 right: 5) ];
				collapsed: [ :aStyle |
					aStyle margin: (BlInsets top: 5 left: 5 bottom: 0 right: 5) ]);
		hMatchParent;
		vFitContent;
		whenExpandedDo: [ activatableChange isExpanded: true ];
		whenCollapsedDo: [ activatableChange isExpanded: false ].

	header := BrVerticalPane new
		hMatchParent;
		vFitContent;
		alignCenterLeft.

	description := BrLabel new
		look: BrGlamorousLabelLook;
		padding: (BlInsets left: 5 right: 5);
		hMatchParent;
		vFitContent;
		beSmallSize.

	header addChildren: { 
		description
	}.

	checkbox := BrCheckbox new
		beSmallSize;
		look: BrGlamorousCheckboxLook new;
		margin: (BlInsets top: 6);
		whenCheckedDo: [ activatableChange isEnabled: true ];
		whenUncheckedDo: [ activatableChange isEnabled: false ].

	expander header: [ header ].

	self addChildren: { 
		checkbox.
		expander }
]

{ #category : #'event handling' }
GtUserActivatableChangeWithExpanderElement >> onEnablementChanged [

	activatableChange isEnabled
		ifTrue: [ checkbox check ]
		ifFalse: [ checkbox uncheck ]
]
