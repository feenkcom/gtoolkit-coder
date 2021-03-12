Class {
	#name : #GtSourceCoderViewModel,
	#superclass : #GtCoderUIModel,
	#instVars : [
		'hasFocus',
		'expanded',
		'editorState',
		'evaluationResult'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Model'
}

{ #category : #accessing }
GtSourceCoderViewModel >> basicFocus: aBoolean [
	hasFocus := aBoolean
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> discardChanges [
	self coder discardChanges
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doIt: aSourceIntervalOrBlock [
	"Evaluate a piece of source code within an interval and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>
	
	^ self coder
		doIt: aSourceIntervalOrBlock
		thenDo: [ :aResult | self notifyEvaluatedWithResult: aResult ]
]

{ #category : #'api - actions' }
GtSourceCoderViewModel >> doItAll [
	^ self coder doItAllThenDo: [ :aResult | self notifyEvaluatedWithResult: aResult ]
]

{ #category : #accessing }
GtSourceCoderViewModel >> editorState [
	^ editorState
]

{ #category : #accessing }
GtSourceCoderViewModel >> editorState: anObject [
	editorState := anObject
]

{ #category : #accessing }
GtSourceCoderViewModel >> elementClass [
	^ GtExpandableSourceCoderElement
]

{ #category : #accessing }
GtSourceCoderViewModel >> evaluationResult [
	^ evaluationResult
]

{ #category : #accessing }
GtSourceCoderViewModel >> evaluationResult: anObject [
	evaluationResult := anObject
]

{ #category : #'api - ui' }
GtSourceCoderViewModel >> expanded [
	^ expanded
]

{ #category : #'api - ui' }
GtSourceCoderViewModel >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #'api - ui' }
GtSourceCoderViewModel >> focused [
	<return: #Boolean>

	^ hasFocus
]

{ #category : #'api - ui' }
GtSourceCoderViewModel >> focused: aBoolean [
	self focused: aBoolean from: self
]

{ #category : #'api - ui' }
GtSourceCoderViewModel >> focused: aBoolean from: aSourceObject [
	hasFocus = aBoolean
		ifTrue: [ ^ self ].

	hasFocus := aBoolean.
	self notifyFocusChanged: hasFocus from: aSourceObject.

	codersUIModel ifNotNil: [ :theCoders |
		aBoolean
			ifTrue: [ theCoders focusCoderUIModel: self  ]
			ifFalse: [ theCoders unfocusCoderUIModel: self ] ]
]

{ #category : #'gt-extension' }
GtSourceCoderViewModel >> gtInfo [
	^ Array streamContents: [ :aStream |
		aStream nextPut: (#coderModel -> self coder).
		aStream nextPut: (#hasFocus -> self focused).
		aStream nextPut: (#expanded -> self expanded).
		
		self editorState ifNotNil: [ :theCompositeMemento |
			theCompositeMemento mementos do: [ :eachMemento |
				aStream nextPut: (eachMemento label -> eachMemento value) ] ] ]
]

{ #category : #'gt-extension' }
GtSourceCoderViewModel >> gtInfoFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Info';
		priority: 0;
		items: [ self gtInfo ];
		actionUpdateButtonTooltip: 'Refresh';
		column: 'Property' 
			item: [ :eachItem :eachIndex | 
				eachItem key asRopedText foreground: Color gray ]
			width: 150;
		column: 'Value' 
			text: [ :eachItem | eachItem value gtDisplayText ];
		send: [ :assoc | assoc value ]
]

{ #category : #initialization }
GtSourceCoderViewModel >> initialize [
	super initialize.
	
	hasFocus := false.
	expanded := true
]

{ #category : #private }
GtSourceCoderViewModel >> notifyEvaluatedWithResult: anEvaluationResult [
	self announce: (GtSourceCoderViewModelEvaluationAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self coder)
]

{ #category : #private }
GtSourceCoderViewModel >> notifyEvaluatedWithResult: anEvaluationResult source: aSourceObject [
	self announce: (GtSourceCoderViewModelEvaluationAnnouncement new 
		evaluationResult: anEvaluationResult;
		coder: self coder)
]

{ #category : #private }
GtSourceCoderViewModel >> notifyFocusChanged: aBoolean from: aSourceObject [
	self announcerUIModel announce: (GtSourceCoderFocusChanged new 
		focused: aBoolean; 
		source: aSourceObject)
]

{ #category : #accessing }
GtSourceCoderViewModel >> selection [
	self editorState ifNotNil: [ :theCompositeMemento |
			theCompositeMemento mementos do: [ :eachMemento |
				eachMemento isSelectionMemento ifTrue: [
					^ eachMemento value ] ] ].
	^ 1 to: 0
]

{ #category : #accessing }
GtSourceCoderViewModel >> text [
	self editorState ifNotNil: [ :theCompositeMemento |
			theCompositeMemento mementos do: [ :eachMemento |
				eachMemento isTextMemento ifTrue: [
					^ eachMemento value ] ] ].
	^ '' asRopedText
]
