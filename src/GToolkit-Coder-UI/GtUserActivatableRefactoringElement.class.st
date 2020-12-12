Class {
	#name : #GtUserActivatableRefactoringElement,
	#superclass : #BrHorizontalPane,
	#instVars : [
		'activatableRefactoring',
		'description',
		'dangerbar',
		'header',
		'checkbox'
	],
	#category : #'GToolkit-Coder-UI-Refactoring'
}

{ #category : #'instance creation' }
GtUserActivatableRefactoringElement class >> fromActivatableRefactoring: aGtUserActivatableRefactoring [
	^ self new activatableRefactoring: aGtUserActivatableRefactoring
]

{ #category : #accessing }
GtUserActivatableRefactoringElement >> activatableRefactoring [
	^ activatableRefactoring
]

{ #category : #initialization }
GtUserActivatableRefactoringElement >> activatableRefactoring: aGtUserActivatableRefactoring [

	activatableRefactoring ifNotNil: [ activatableRefactoring announcer unsubscribe: self ].
	activatableRefactoring := aGtUserActivatableRefactoring.
	activatableRefactoring announcer weak
		when: #enablementChanged send: #onEnablementChanged to: self.

	self onEnablementChanged.

	description text: aGtUserActivatableRefactoring description. 

	"activatableRefactoring isDangerous
		ifTrue: [ expander look 
			borderPaint: BrGlamorousColors errorBackgroundColor;
			borderFocusedPaint: BrGlamorousColors errorBackgroundColor ]."

	"header addChildren: (activatableRefactoring dangers collect: [ :eachDanger |
		BrEditor new
			beReadOnlyWithSelection;
			look: (BrGlamorousRegularEditorLook new foreground: BrGlamorousColors linkWithErrorColor);
			text: eachDanger description;
			hMatchParent;
			vFitContent ])"
]

{ #category : #initialization }
GtUserActivatableRefactoringElement >> initialize [
	super initialize.

	self hMatchParent.
	self vFitContent.
	self alignCenterLeft.
	
	description := BrEditor new
		padding: (BlInsets left: 5 right: 5);
		margin: (BlInsets empty);
		beReadOnlyWithSelection;
		hMatchParent;
		vFitContent;
		look: BrGlamorousRegularEditorLook new.

	checkbox := BrCheckbox new
		look: BrGlamorousCheckboxLook new;
		margin: (BlInsets top: 0 left: 5 bottom: 0 right: 0);
		whenCheckedDo: [ activatableRefactoring isEnabled: true ];
		whenUncheckedDo: [ activatableRefactoring isEnabled: false ].

	self addChildren: {
		checkbox.
		description
	}
]

{ #category : #'event handling' }
GtUserActivatableRefactoringElement >> onEnablementChanged [
	activatableRefactoring isIndeterminate
		ifTrue: [ checkbox indeterminate ]
		ifFalse: [ activatableRefactoring isEnabled
			ifTrue: [ checkbox check ]
			ifFalse: [ checkbox uncheck ] ]
]
