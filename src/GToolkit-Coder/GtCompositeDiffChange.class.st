Class {
	#name : #GtCompositeDiffChange,
	#superclass : #GtDiffChange,
	#instVars : [
		'changes',
		'from',
		'to'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'instance creation' }
GtCompositeDiffChange class >> forChanges: aCollection [
	^ self new
		changes: aCollection;
		yourself
]

{ #category : #'instance creation' }
GtCompositeDiffChange class >> from: from to: to changes: aCollection [
	^ self new
		from: from;
		to: to;
		changes: aCollection;
		yourself
]

{ #category : #formatting }
GtCompositeDiffChange >> applyAttributesToInput: aText [
	changes do: [ :each | each applyAttributesToInput: aText ]
]

{ #category : #formatting }
GtCompositeDiffChange >> applyAttributesToOutput: aText [
	changes do: [ :each | each applyAttributesToOutput: aText ]
]

{ #category : #accessing }
GtCompositeDiffChange >> changes [
	^ changes
]

{ #category : #accessing }
GtCompositeDiffChange >> changes: aCollection [
	changes := aCollection
]

{ #category : #accessing }
GtCompositeDiffChange >> from [
	^ from
]

{ #category : #accessing }
GtCompositeDiffChange >> from: anObject [
	from := anObject
]

{ #category : #inspecting }
GtCompositeDiffChange >> gtChangeViewFor: aView [
	<gtView>
	^ aView columnedTree
		priority: 10;
		title: 'Changes';
		items: [ self changes ];
		children: [ :each | 
			each isReplacement
				ifTrue: [ {each deletionChange.
						each insertionChange} ]
				ifFalse: [ #() ] ];
		column: 'Kind'
			text: [ :each | (each class name removePrefix: 'Gt') removeSuffix: 'DiffChange' ]
			width: 150;
		column: 'Range'
			text: [ :each | each range ]
			width: 100;
		column: 'Objects' text: [ :each | each gtObjectsText ]
]

{ #category : #inspecting }
GtCompositeDiffChange >> gtTextView: aView [
	<gtView>
	from isString ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Text';
		stencil: [ | pane fromText toText fromEditor toEditor |
			pane := BrHorizontalPane new.
			pane matchParent.
			pane padding: (BlInsets all: 10).
			fromText := from asRopedText glamorousRegularFont.
			toText := to asRopedText glamorousRegularFont.
			self applyAttributesToInput: fromText.
			self applyAttributesToOutput: toText.
			fromEditor := BrEditor new
					focusability: BlFocusability none;
					beReadOnlyWithSelection;
					matchParent;
					aptitude: BrGlamorousCodeEditorAptitude.
			fromEditor editor text: fromText.
			toEditor := BrEditor new
					focusability: BlFocusability none;
					beReadOnlyWithSelection;
					matchParent;
					aptitude: BrGlamorousCodeEditorAptitude.
			toEditor editor text: toText.
			pane
				addChild: fromEditor;
				addChild: toEditor.
			pane ]
]

{ #category : #initialization }
GtCompositeDiffChange >> initialize [
	super initialize.
	changes := #()
]

{ #category : #accessing }
GtCompositeDiffChange >> to [
	^ to
]

{ #category : #accessing }
GtCompositeDiffChange >> to: aCollection [
	to := aCollection
]
