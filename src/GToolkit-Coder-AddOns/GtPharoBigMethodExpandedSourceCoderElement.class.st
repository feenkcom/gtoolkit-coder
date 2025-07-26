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
	super initialize.
	selectorLabel := BlAttributedTextElement new
			id: GtSourceCoderCollapsedTextId;
			editorMeasurement;
			bold;
			glamorousCodeFont;
			foreground: self theme label defaultTextForeground;
			text: 'selector' asRopedText.
	label := BlAttributedTextElement new
			editorMeasurement;
			italic;
			glamorousCodeFont;
			foreground: self theme label defaultTextForeground;
			text: 'Large Method. Use inspect button to see source' asRopedText.
	self removeChild: editorElement.
	self addChildFirst: label.
	self addChildFirst: selectorLabel
]
