Class {
	#name : #GtPharoCodeHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#traits : 'TGtPharoProgramNodeVisitor',
	#classTraits : 'TGtPharoProgramNodeVisitor classTrait',
	#instVars : [
		'stream'
	],
	#category : #'GToolkit-Coder-Pharo-AddOns-Highlighter'
}

{ #category : #visiting }
GtPharoCodeHighlighter >> acceptNode: aSmaCCParseNode [
	"Using acceptVisitor: is the correct way to use a visitor pattern.
	The constraint was design for RB"
	<gtIgnoreConstraint: #GtRBAcceptVisitorCalledFromNonVisitingMethods>

	aSmaCCParseNode isNil
		ifTrue: [ ^ #() ].
	
	^ stream
		ifNotNil: [ aSmaCCParseNode acceptVisitor: self ]
		ifNil: [
			Array streamContents: [ :aStream |
				stream := aStream.
				[ aSmaCCParseNode acceptVisitor: self ]
					ensure: [ stream := nil ] ] ]
]

{ #category : #'api - styling' }
GtPharoCodeHighlighter >> style: aText ast: theAst [
	text := aText.
	[ 
		| theIntervals |
		
		theIntervals := self accept: theAst.
		self style: aText intervals: theIntervals ]
			ensure: [ text := nil ]
]

{ #category : #'api - styling' }
GtPharoCodeHighlighter >> style: aText intervals: theIntervals [
	theIntervals do: [ :eachHighlightInterval |
		aText
			attributes: HighlightAttributes
			from: eachHighlightInterval first
			to: eachHighlightInterval last ]
]
