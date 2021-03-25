Class {
	#name : #GtPharoStylerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Pharo-Examples-Stylers'
}

{ #category : #examples }
GtPharoStylerExamples >> invalidSyntaxWithCascade [
	<gtExample>
	| aCoder anAst aSourceText aRedInterval |
	
	aCoder := GtPharoSnippetCoder forSource: 'object := Object new
	isNil;
	notNil
Object new' asRopedText.

	anAst := aCoder astAwait.
	aSourceText := aCoder sourceText copy unstyled.
	
	GtPharoStyler new
		coderViewModel: aCoder asCoderViewModel;
		style: aSourceText
		ast: anAst.
	
	aRedInterval := 1 to: 0.
	aSourceText
		findAttributeSuchThat: [ :eachAttribute | (eachAttribute isKindOf: BlTextForegroundAttribute) and: [ eachAttribute paint = Color red ] ]
		indicesDo: [ :aStartPosition :anEndPosition | aRedInterval := aStartPosition to: anEndPosition ].	

	self assert: aRedInterval equals: (38 to: 43).

	^ aSourceText
]
