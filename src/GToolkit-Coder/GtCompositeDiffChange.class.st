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

{ #category : #iterating }
GtCompositeDiffChange >> deletionChangesDo: aBlock [
	changes do: [ :each | each deletionChangesDo: aBlock ]
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
GtCompositeDiffChange >> gtListView: aView [
	<gtView>
	from isString ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'List';
		stencil: [ | pane fromList toList deletedIndices insertedIndices |
			deletedIndices := Set new.
			self
				deletionChangesDo: [ :each | deletedIndices addAll: (each startIndex to: each stopIndex) ].
			insertedIndices := Set new.
			self
				insertionChangesDo: [ :each | insertedIndices addAll: (each startIndex to: each stopIndex) ].
			pane := BrHorizontalPane new.
			pane matchParent.
			pane padding: (BlInsets all: 10).
			fromList := BrColumnedList new.
			fromList matchParent.
			fromList column
				width: 45;
				title: 'Index';
				stencil: [ :each :i | 
					BrLabel new
						aptitude: BrGlamorousLabelAptitude new;
						text: (i asRopedText foreground: Color gray) ].
			fromList column
				title: 'Value';
				stencil: [ :each :i | 
					| text |
					text := each gtDisplayText.
					(deletedIndices includes: i)
						ifTrue: [ text highlight: GtDeletionDiffChange highlightColor ].
					BrLabel new
						aptitude: BrGlamorousLabelAptitude new;
						text: text ].
			fromList items: from.
			toList := BrColumnedList new.
			toList matchParent.
			toList column
				width: 45;
				title: 'Index';
				stencil: [ :each :i | 
					BrLabel new
						aptitude: BrGlamorousLabelAptitude new;
						text: (i asRopedText foreground: Color gray) ].
			toList column
				title: 'Value';
				stencil: [ :each :i | 
					| text |
					text := each gtDisplayText.
					(insertedIndices includes: i)
						ifTrue: [ text highlight: GtInsertionDiffChange highlightColor ].
					BrLabel new
						aptitude: BrGlamorousLabelAptitude new;
						text: text ].
			toList items: to.
			pane
				addChild: fromList;
				addChild: toList.
			pane ]
]

{ #category : #inspecting }
GtCompositeDiffChange >> gtTextView: aView [
	<gtView>
	from isString ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Text';
		stencil: [ (GtDiffElement onChange: self) addAptitude: GtDiffFlatAptitude ]
]

{ #category : #initialization }
GtCompositeDiffChange >> initialize [
	super initialize.
	changes := #()
]

{ #category : #iterating }
GtCompositeDiffChange >> insertionChangesDo: aBlock [
	changes do: [ :each | each insertionChangesDo: aBlock ]
]

{ #category : #accessing }
GtCompositeDiffChange >> to [
	^ to
]

{ #category : #accessing }
GtCompositeDiffChange >> to: aCollection [
	to := aCollection
]
