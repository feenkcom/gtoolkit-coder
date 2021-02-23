Class {
	#name : #GtSourceCoderUIModel,
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
GtSourceCoderUIModel >> basicFocus: aBoolean [
	hasFocus := aBoolean
]

{ #category : #'api - actions' }
GtSourceCoderUIModel >> discardChanges [
	self coder discardChanges
]

{ #category : #accessing }
GtSourceCoderUIModel >> editorState [
	^ editorState
]

{ #category : #accessing }
GtSourceCoderUIModel >> editorState: anObject [
	editorState := anObject
]

{ #category : #accessing }
GtSourceCoderUIModel >> elementClass [
	^ GtExpandableSourceCoderElement
]

{ #category : #accessing }
GtSourceCoderUIModel >> evaluationResult [
	^ evaluationResult
]

{ #category : #accessing }
GtSourceCoderUIModel >> evaluationResult: anObject [
	evaluationResult := anObject
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> expanded [
	^ expanded
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> focused [
	<return: #Boolean>

	^ hasFocus
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> focused: aBoolean [
	self focused: aBoolean from: self
]

{ #category : #'api - ui' }
GtSourceCoderUIModel >> focused: aBoolean from: aSourceObject [
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
GtSourceCoderUIModel >> gtInfo [
	^ Array streamContents: [ :aStream |
		aStream nextPut: (#coderModel -> self coder).
		aStream nextPut: (#hasFocus -> self focused).
		aStream nextPut: (#expanded -> self expanded).
		
		self editorState ifNotNil: [ :theCompositeMemento |
			theCompositeMemento mementos do: [ :eachMemento |
				aStream nextPut: (eachMemento label -> eachMemento value) ] ] ]
]

{ #category : #'gt-extension' }
GtSourceCoderUIModel >> gtInfoFor: aView [
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
GtSourceCoderUIModel >> initialize [
	super initialize.
	
	hasFocus := false.
	expanded := true
]

{ #category : #private }
GtSourceCoderUIModel >> notifyFocusChanged: aBoolean from: aSourceObject [
	self announcerUIModel announce: (GtSourceCoderFocusChanged new 
		focused: aBoolean; 
		source: aSourceObject)
]

{ #category : #accessing }
GtSourceCoderUIModel >> selection [
	self editorState ifNotNil: [ :theCompositeMemento |
			theCompositeMemento mementos do: [ :eachMemento |
				eachMemento isSelectionMemento ifTrue: [
					^ eachMemento value ] ] ].
	^ 1 to: 0
]

{ #category : #accessing }
GtSourceCoderUIModel >> text [
	self editorState ifNotNil: [ :theCompositeMemento |
			theCompositeMemento mementos do: [ :eachMemento |
				eachMemento isTextMemento ifTrue: [
					^ eachMemento value ] ] ].
	^ '' asRopedText
]
