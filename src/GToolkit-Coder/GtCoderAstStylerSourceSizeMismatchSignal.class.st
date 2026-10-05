Class {
	#name : #GtCoderAstStylerSourceSizeMismatchSignal,
	#superclass : #GtCoderAstStylerSignal,
	#instVars : [
		'coderAst',
		'coderAstDocumentId'
	],
	#category : #'GToolkit-Coder-Signals'
}

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAst [
	^ coderAst
]

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAst: anObject [
	coderAst := anObject
]

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAstDocumentId [
	^ coderAstDocumentId
]

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAstDocumentId: anObject [
	coderAstDocumentId := anObject
]

{ #category : #printing }
GtCoderAstStylerSourceSizeMismatchSignal >> printOneLineContentsOn: aStream [
	"Put the two sizes that disagreed next to each other, in the same order as
	${method:GtCoderAstStylerStartingSignal>>#printOneLineContentsOn:}$, so the two lines of one styling
	attempt read as a pair.

	The sizes are derived rather than stored, and derived the way `privateStyle:` compared them. A nil AST
	or a released text is tolerated: this signal is usually read long after the run, and
	${method:GtTextEditorTimelineEntry>>#details}$ answers an empty string when a one line output raises,
	which would hide the one fact worth having.

	The two document ids are not necessarily comparable and are deliberately not labelled by provenance.
	When the coder is backed by the rust editor the text's id is assigned by the rust side while the AST's
	is a Pharo side one, so they come from different counters; for any other coder both are Pharo side.
	This styler serves every Pharo coder, so it cannot know which case it is in."
	| anAstSourceSize aStyledTextSize |
	anAstSourceSize := [ coderAst
			ifNotNil: [ :theCoderAst | theCoderAst ast ifNotNil: [ :theAst | theAst source size ] ] ]
			on: Error
			do: [ :anError | nil ].
	aStyledTextSize := [ styledText ifNotNil: [ :aText | aText characters size ] ]
			on: Error
			do: [ :anError | nil ].

	aStream
		nextPutAll: 'Ast styling skipped, text ';
		nextPutAll: styledTextDocumentId printString;
		nextPutAll: ' size ';
		print: aStyledTextSize;
		nextPutAll: ', ast ';
		nextPutAll: coderAstDocumentId printString;
		nextPutAll: ' source size ';
		print: anAstSourceSize;
		space
]
