Class {
	#name : #GtUserActivatableRefactoringElement,
	#superclass : #BlElement,
	#instVars : [
		'activatableRefactoring',
		'expander',
		'checkbox',
		'description',
		'dangerbar',
		'header'
	],
	#category : #'GToolkit-Coder-Refactorings - UI'
}

{ #category : #'instance creation' }
GtUserActivatableRefactoringElement class >> fromActivatableRefactoring: aGtUserActivatableRefactoring [
	^ self new fromActivatableRefactoring: aGtUserActivatableRefactoring
]

{ #category : #accessing }
GtUserActivatableRefactoringElement >> activatableRefactoring [
	^ activatableRefactoring
]

{ #category : #initialization }
GtUserActivatableRefactoringElement >> fromActivatableRefactoring: aGtUserActivatableRefactoring [

	activatableRefactoring := aGtUserActivatableRefactoring.

	activatableRefactoring isEnabled
		ifTrue: [ checkbox check ]
		ifFalse: [ checkbox uncheck ].

	description text: aGtUserActivatableRefactoring description. 

	activatableRefactoring isDangerous
		ifTrue: [ expander look 
			borderPaint: BrGlamorousColors errorBackgroundColor;
			borderFocusedPaint: BrGlamorousColors errorBackgroundColor ].

	expander content: [
		BrVerticalPane new
			hMatchParent;
			vFitContent;
			addChildren: (activatableRefactoring allChanges collect: [ :eachChange | eachChange asElement ])].

	header addChildren: (activatableRefactoring dangers collect: [ :eachDanger |
		BrEditor new
			beReadOnlyWithSelection;
			look: (BrGlamorousRegularEditorLook new foreground: BrGlamorousColors linkWithErrorColor);
			text: eachDanger description;
			hMatchParent;
			vFitContent ])
]

{ #category : #initialization }
GtUserActivatableRefactoringElement >> initialize [
	super initialize.

	expander := BrExpander new.
	expander
		look: (GtCoderExpanderLook new
			cornerRadius: 3;
			padding: (BlInsets empty);
			doNotReplaceHeader);
		hMatchParent;
		margin: (BlInsets all: 5);
		vFitContent.

	self layout: (BlLinearLayout horizontal).
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	header := BrVerticalPane new
		hMatchParent;
		vFitContent;
		alignCenterLeft.

	description := BrEditor new
		padding: (BlInsets left: 5 right: 5);
		beReadOnlyWithSelection;
		hMatchParent;
		vFitContent;
		look: BrGlamorousRegularEditorLook new.

	header addChildren: { 
		description
	}.

	checkbox := BrCheckbox new
		look: BrGlamorousCheckboxLook new - BrSizeAdjustmentLook;
		hExact: 16;
		vExact: 30;
		margin: (BlInsets top: 5 left: 5 bottom: 0 right: 0);
		whenCheckedDo: [ activatableRefactoring isEnabled: true ];
		whenUncheckedDo: [ activatableRefactoring isEnabled: false ].

	expander header: [ header ].

	self addChildren: { 
		checkbox.
		expander }
]
