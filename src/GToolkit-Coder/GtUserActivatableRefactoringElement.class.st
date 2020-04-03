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

	checkbox activated: activatableRefactoring isEnabled.
	
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
			vFitContent
	])
]

{ #category : #initialization }
GtUserActivatableRefactoringElement >> initialize [
	super initialize.
	
	expander := BrExpander new.
	expander
		look: (GtCoderExpanderLook new
			borderWidth: 1;
			cornerRadius: 3;
			doNotReplaceHeader);
		hMatchParent;
		vFitContent.
	
	self layout: (BlLinearLayout horizontal).
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	self margin: (BlInsets top: 5 bottom: 5).
	
	header := BrVerticalPane new
		hMatchParent;
		vFitContent;
		alignCenterLeft.

	description := BrEditor new
		beReadOnlyWithSelection;
		hMatchParent;
		vFitContent;
		look: BrGlamorousRegularEditorLook new.

	header addChildren: { 
		description
	}.
	
	checkbox := BrToggle new
		look: BrHydraSwitchWithoutTrackLook new.
	
	expander header: [ header ].
	
	self addChildren: { 
		checkbox.
		expander }
]
