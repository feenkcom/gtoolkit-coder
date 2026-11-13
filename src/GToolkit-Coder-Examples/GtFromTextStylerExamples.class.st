"
Examples of copying text attributes and checking source and target alignment.
"
Class {
	#name : #GtFromTextStylerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #examples }
GtFromTextStylerExamples >> attributedDiffText [
	<gtExample>
	| source target styled styler |
	source := 'alpha beta' asRopedText.
	(source from: 1 to: 5)
		foreground: Color blue;
		bold.
	(source from: 7 to: 10) foreground: Color red.
	source glamorousCodeFont.
	target := (source asString , String cr) asRopedText.
	styler := GtFromTextStyler new sourceText: source.
	styled := styler style: target.
	self assert: styled asString equals: target asString.
	1
		to: source size
		do: [ :index | 
			self
				assert: ((styled attributesAt: index) includesAll: (source attributesAt: index)) ].
	self assert: (styler style: styled) asString equals: target asString.
	^ styled
]

{ #category : #examples }
GtFromTextStylerExamples >> diffTextAlignment [
	<gtExample>
	| styler emptyStyler |
	styler := GtFromTextStyler new sourceText: 'abc' asRopedText.
	self
		assert: ([ styler style: 'abd' asRopedText.
			false ] on: Error do: [ :error | true ]).
	self
		assert: ([ styler style: 'ab' asRopedText.
			false ] on: Error do: [ :error | true ]).
	self assert: (styler style: 'abc' asRopedText) asString equals: 'abc'.
	emptyStyler := GtFromTextStyler new sourceText: '' asRopedText.
	self assert: (emptyStyler style: '' asRopedText) isEmpty.
	self
		assert: (emptyStyler style: String cr asRopedText) asString
		equals: String cr.
	^ styler
]
