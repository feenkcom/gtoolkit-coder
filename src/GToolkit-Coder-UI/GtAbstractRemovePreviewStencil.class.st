Class {
	#name : #GtAbstractRemovePreviewStencil,
	#superclass : #BrStencil,
	#instVars : [
		'anElement'
	],
	#category : #'GToolkit-Coder-UI-Utilities'
}

{ #category : #accessing }
GtAbstractRemovePreviewStencil >> anElement [
	^ anElement
]

{ #category : #accessing }
GtAbstractRemovePreviewStencil >> anElement: element [
	^ anElement := element
]

{ #category : #accessing }
GtAbstractRemovePreviewStencil >> createPreviewContainerForItemNamed: itemName withReferences: references [
	| referencesButton container stillReferencedLabel noReferencesLabel waitingLabel |
	noReferencesLabel := self noReferencesLabel.
	noReferencesLabel
		text: itemName asRopedText bold , ' is not referenced' asRopedText.
	waitingLabel := self waitingLabel.
	stillReferencedLabel := self stillReferencedLabelFor: itemName.
	referencesButton := self referencesButtonFor: references.

	container := BrHorizontalPane new
			fitContent;
			withAsyncSinkDo: [ :anElementSink | 
				anElementSink
					sink: AsyncCounterSink new;
					whenPending: [ :aContainer :aSink | 
						aSink count > 0
							ifTrue: [ waitingLabel visibility: BlVisibility gone.
								stillReferencedLabel visibility: BlVisibility visible.
								referencesButton visibility: BlVisibility visible ].

						referencesButton
							label: (String
									streamContents: [ :aStream | 
										aStream
											print: aSink count;
											space;
											nextPutAll: ('method' asPluralBasedOn: aSink count);
											nextPutAll: '...' ]) ];
					whenSuccess: [ :aContainer :aSink | 
						waitingLabel visibility: BlVisibility gone.

						aSink count > 0
							ifTrue: [ stillReferencedLabel visibility: BlVisibility visible.
								referencesButton visibility: BlVisibility visible ]
							ifFalse: [ stillReferencedLabel visibility: BlVisibility gone.
								referencesButton visibility: BlVisibility gone.
								noReferencesLabel visibility: BlVisibility visible ].

						referencesButton
							label: (String
									streamContents: [ :aStream | 
										aStream
											print: aSink count;
											space;
											nextPutAll: ('method' asPluralBasedOn: aSink count) ]) ] ].

	container asyncSink forwardStream: references asAsyncStream.

	container
		addChildren: {waitingLabel.
				stillReferencedLabel visibility: BlVisibility gone.
				referencesButton visibility: BlVisibility gone.
				noReferencesLabel visibility: BlVisibility gone}.
	^ container
]

{ #category : #accessing }
GtAbstractRemovePreviewStencil >> noReferencesLabel [
	| noReferencesLabel |
	noReferencesLabel := BrLabel new
			margin: (BlInsets all: 10);
			aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
			text: 'Remove?' asRopedText.
	^ noReferencesLabel
]

{ #category : #accessing }
GtAbstractRemovePreviewStencil >> referencesButtonFor: references [
	^ BrButton new
		aptitude: BrGlamorousLinkSquaredButtonWithLabelAptitude new glamorousCodeSmallSize;
		beSmallSize;
		margin: (BlInsets
				top: 10
				left: 2
				bottom: 10
				right: 10);
		label: '0 methods';
		action: [ self anElement phlow spawnObject: references ]
]

{ #category : #accessing }
GtAbstractRemovePreviewStencil >> stillReferencedLabelFor: name [
	^ BrLabel new
		margin: (BlInsets
				top: 10
				left: 10
				bottom: 10
				right: 0);
		aptitude: BrGlamorousLabelAptitude new;
		text: name asRopedText bold , ' is still referenced in ' asRopedText
]

{ #category : #accessing }
GtAbstractRemovePreviewStencil >> waitingLabel [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new italic;
		margin: (BlInsets all: 10);
		text: 'Searching references...'
]
