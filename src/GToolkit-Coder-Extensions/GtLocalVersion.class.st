Class {
	#name : #GtLocalVersion,
	#superclass : #Object,
	#instVars : [
		'previousChangeRecord',
		'currentMethod',
		'changeRecord'
	],
	#category : #'GToolkit-Coder-Extensions'
}

{ #category : #'instance creation' }
GtLocalVersion class >> change: aChangeRecord previousChange: aPreviousChangeRecord currentMethod: aMethod [
	^ self new
		initializeWithChange: aChangeRecord
		previousChange: aPreviousChangeRecord
		currentMethod: aMethod
]

{ #category : #accessing }
GtLocalVersion >> currentSourceCodeInImage [
	^ currentMethod 
		ifNil: [ '' ]
		ifNotNil: [ :aMethod |
			aMethod sourceCode ]
]

{ #category : #'gt - extensions' }
GtLocalVersion >> gtActionLoadVersionFor: anAction [
	<gtAction>
	
	^ changeRecord gtActionLoadVersionFor: anAction
]

{ #category : #'gt - extensions' }
GtLocalVersion >> gtViewDiffWithInImageCodeFor: aView [
	<gtView>
	
	^ aView explicit 
		title: 'Diff (current)';
		priority: 10;
		stencil: [ 
			| change styler |

			change := GtDiffBuilder
				computeDifferencesFrom: self sourceCode 
				to: self currentSourceCodeInImage
				using: GtSmaCCDiffSplitter forPharo.
				
			styler := GtCodeDiffRBTextStyler new.

			GtDiffElementWithLabelStencil new
				fromLabelText: 'Version';
				toLabelText: 'Image';
				change: change;
				styler: styler ] 
]

{ #category : #'gt - extensions' }
GtLocalVersion >> gtViewDiffWithPreviousFor: aView [
	<gtView>
	
	^ aView explicit 
		title: 'Diff';
		priority: 5;
		stencil: [ 
			| change styler |

			change := GtDiffBuilder
				computeDifferencesFrom: self previousSourceCode 
				to: self sourceCode
				using: GtSmaCCDiffSplitter forPharo.
				
			styler := GtCodeDiffRBTextStyler new.

			GtDiffElementWithLabelStencil new
				fromLabelText: 'Previous';
				toLabelText: 'Changed';
				change: change;
				styler: styler ] 
]

{ #category : #initialization }
GtLocalVersion >> initializeWithChange: aChangeRecord previousChange: aPreviousChangeRecord currentMethod: aMethod [ 
	changeRecord := aChangeRecord.
	previousChangeRecord := aPreviousChangeRecord.
	currentMethod := aMethod.
]

{ #category : #actions }
GtLocalVersion >> loadChange [ 
	^ changeRecord asMCMethodDefinition load
]

{ #category : #accessing }
GtLocalVersion >> previousSourceCode [
	^ previousChangeRecord
		ifNil: [ '' ] 
		ifNotNil: [ :aChangeRecord |
			aChangeRecord sourceCode ]
]

{ #category : #accessing }
GtLocalVersion >> printOn: aStream [ 
	super printOn: aStream .
	
	aStream parenthesize: [
		changeRecord printOn: aStream ]
]

{ #category : #accessing }
GtLocalVersion >> sourceCode [
	^ changeRecord sourceCode
]

{ #category : #accessing }
GtLocalVersion >> timeStamp [
	^ changeRecord timeStamp
]
