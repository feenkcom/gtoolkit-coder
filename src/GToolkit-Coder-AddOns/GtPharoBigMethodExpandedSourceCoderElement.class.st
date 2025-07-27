Class {
	#name : #GtPharoBigMethodExpandedSourceCoderElement,
	#superclass : #GtSourceCoderExpandedContentElement,
	#instVars : [
		'label',
		'selectorLabel'
	],
	#category : #'GToolkit-Coder-AddOns-Big Methods'
}

{ #category : #initialization }
GtPharoBigMethodExpandedSourceCoderElement >> initialize [
	| coderText inspectIt |
	super initialize.
	selectorLabel := BlAttributedTextElement new
			id: GtSourceCoderCollapsedTextId;
			editorMeasurement;
			bold;
			glamorousCodeFont;
			foreground: self theme label defaultTextForeground;
			text: 'selector' asRopedText.
	inspectIt := 'Inspect it' asRopedText bold.
	coderText := 'This is a large method. ' asRopedText.
	coderText
		attribute: (GtButtonAttribute new
				beAppend;
				stencil: [ BrButton new
						aptitude: BrGlamorousLinkSquaredButtonWithLabelAptitude new;
						beSmallSize;
						margin: (BlInsets
								top: 1
								left: 0
								bottom: 0
								right: 0);
						padding: (BlInsets
								top: 3
								left: 5
								bottom: 3
								right: 5);
						label: 'Inspect it';
						action: [ :aButton | aButton phlow spawnObject: self textualCoderViewModel methodReference ] ]).
	coderText := coderText , ' to see source' asRopedText.
	label := BrEditor new
			aptitude: (BrGlamorousRegularEditorAptitude new
					glamorousCodeFont;
					foreground: self theme label defaultTextForeground);
			text: coderText.
	self removeChild: editorElement.
	self addChildFirst: label.
	self addChildFirst: selectorLabel
]

{ #category : #'as yet unclassified' }
GtPharoBigMethodExpandedSourceCoderElement >> onPostTextualCoderViewModelChanged [
	super onPostTextualCoderViewModelChanged.
	textualCoderViewModel
		ifNotNil: [ selectorLabel text: textualCoderViewModel coder selector asRopedText ]
]
