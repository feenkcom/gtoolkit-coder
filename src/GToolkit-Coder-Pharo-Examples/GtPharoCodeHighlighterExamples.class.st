Class {
	#name : #GtPharoCodeHighlighterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Pharo-Examples-Stylers'
}

{ #category : #'ast pattern' }
GtPharoCodeHighlighterExamples >> astPatternIfTrueIfFalse [
	<gtExample>
	<noTest>
	| theIntervals |
	
	"we need smacc pharo pattern parser (an alternative to RBPatternParser)"
	self flag: #TODO.

	theIntervals := GtPharoAstPatternHighlighter new
		ast: (GtPharoParser
			parseWithErrors: 'a ifTrue: [] ifFalse: []'
			startingAt: GtPharoParser startingStateForStatement);
		accept: self exampleMethodAst.

	"self assert: theIntervals equals: {(207 to: 207). (661 to: 661)}."

	^ self visualiseIntervals: theIntervals
]

{ #category : #'comments reference' }
GtPharoCodeHighlighterExamples >> commentReferenceA [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoCommentsReferenceHighlighter new
		commentsFilter: (GtSearchCommentsFilter new text: 'a');
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(207 to: 207). (661 to: 661)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'comments reference' }
GtPharoCodeHighlighterExamples >> commentReferenceFalse [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoCommentsReferenceHighlighter new
		commentsFilter: (GtSearchCommentsFilter new text: 'false');
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(367 to: 371)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'comments reference' }
GtPharoCodeHighlighterExamples >> commentReferenceNotFound [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoCommentsReferenceHighlighter new
		commentsFilter: (GtSearchCommentsFilter new text: 'waterfall');
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #private }
GtPharoCodeHighlighterExamples >> exampleMethodAst [
	<gtExample>
	| anAst |
	anAst := GtPharoParser 
		parseWithErrors: (self class >> self exampleMethodSelector) sourceCode
		startingAt: GtPharoParser startingStateForMethod.
		
	self assert: anAst notNil.
	self assert: (anAst isKindOf: GtPharoMethodNode).
	
	^ anAst
]

{ #category : #private }
GtPharoCodeHighlighterExamples >> exampleMethodSelector [
	^ #exampleWithNumber:
]

{ #category : #private }
GtPharoCodeHighlighterExamples >> exampleWithNumber: x [
    "A method that illustrates every part of Smalltalk method syntax
    except primitives. It has unary, binary, and keyword messages,
    declares arguments and temporaries, accesses a global variable
    (but not an instance variable), uses literals (array, character,
    symbol, string, integer, float), uses the pseudo variables
    true, false, nil, self, and super, and has sequence, assignment,
    return and cascade. It has both zero argument and one argument blocks."
    <syntaxOn: #postcard>
    | y |
    true & false not & (nil isNil) 
		ifTrue: [100] ifFalse: [self inspect].
    y := self size + super size.
    #($a #a "a" 1 1.0)
        do: [ :each |
            Transcript show: 'each class: ';
                       show: (each class name);
                       space ].
    ^x < y
]

{ #category : #implementor }
GtPharoCodeHighlighterExamples >> implementorOtherMethod [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoImplementorHighlighter new
		selector: self exampleMethodSelector, #Other;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #'implementor pattern' }
GtPharoCodeHighlighterExamples >> implementorPatternPart [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoImplementorPatternHighlighter new
		pattern: #example;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(1 to: 7)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'implementor pattern' }
GtPharoCodeHighlighterExamples >> implementorPatternSelector [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoImplementorPatternHighlighter new
		pattern: self exampleMethodSelector;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(1 to: 18)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'implementor pattern' }
GtPharoCodeHighlighterExamples >> implementorPatternSelf [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoImplementorPatternHighlighter new
		pattern: 'self';
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #implementor }
GtPharoCodeHighlighterExamples >> implementorThisMethod [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoImplementorHighlighter new
		selector: self exampleMethodSelector;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(1 to: 18)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #pragma }
GtPharoCodeHighlighterExamples >> pragmaOtherMethod [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoPragmaHighlighter new
		symbol: #pragma;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #pragma }
GtPharoCodeHighlighterExamples >> pragmaThisMethod [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoPragmaHighlighter new
		symbol: #syntaxOn:;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(506 to: 526)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #pragma }
GtPharoCodeHighlighterExamples >> pragmaThisMethodWithoutColons [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoPragmaHighlighter new
		symbol: #syntaxOn;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #'selector and literal reference' }
GtPharoCodeHighlighterExamples >> selectorAndLiteralReferenceA [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSelectorReferenceAndLiteralHighlighter new
		selector: #a;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(657 to: 658)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'selector and literal reference' }
GtPharoCodeHighlighterExamples >> selectorAndLiteralReferenceIfTrue [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSelectorReferenceAndLiteralHighlighter new
		selector: #ifTrue:;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #'selector and literal reference' }
GtPharoCodeHighlighterExamples >> selectorAndLiteralReferenceIfTrueIfFalse [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSelectorReferenceAndLiteralHighlighter new
		selector: #ifTrue:ifFalse:;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(576 to: 582). (590 to: 597)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'selector and literal reference' }
GtPharoCodeHighlighterExamples >> selectorAndLiteralReferencePostcard [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSelectorReferenceAndLiteralHighlighter new
		selector: #postcard;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(517 to: 525)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'selector and literal reference' }
GtPharoCodeHighlighterExamples >> selectorAndLiteralReferenceShow [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSelectorReferenceAndLiteralHighlighter new
		selector: #show:;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(716 to: 720). (761 to: 765)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #substring }
GtPharoCodeHighlighterExamples >> substringInComment [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringHighlighter new
		substring: 'arguments';
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(171 to: 179)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'substring literal' }
GtPharoCodeHighlighterExamples >> substringLiteralClass [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringLiteralHighlighter new
		substring: 'class';
		caseSensitive: false;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(728 to: 732)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'substring literal' }
GtPharoCodeHighlighterExamples >> substringLiteralEachCaseInsensitive [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringLiteralHighlighter new
		substring: 'eAcH';
		caseSensitive: false;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(723 to: 726)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'substring literal' }
GtPharoCodeHighlighterExamples >> substringLiteralEachCaseSensitive [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringLiteralHighlighter new
		substring: 'eAcH';
		caseSensitive: true;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #'substring literal' }
GtPharoCodeHighlighterExamples >> substringLiteralNotFound [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringLiteralHighlighter new
		substring: 'waterfall';
		caseSensitive: false;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #'substring literal' }
GtPharoCodeHighlighterExamples >> substringLiteralSpace [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringLiteralHighlighter new
		substring: ' ';
		caseSensitive: false;
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(727 to: 727). (734 to: 734)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #substring }
GtPharoCodeHighlighterExamples >> substringNotFound [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringHighlighter new
		substring: 'waterfall';
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #substring }
GtPharoCodeHighlighterExamples >> substringSelf [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoSubstringHighlighter new
		substring: 'self';
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(379 to: 382). (600 to: 603). (624 to: 627)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'variable reference' }
GtPharoCodeHighlighterExamples >> variableReferenceNotFound [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoVariableReferenceHighlighter new
		variableName: 'waterfall';
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: #().

	^ self visualiseIntervals: theIntervals
]

{ #category : #'variable reference' }
GtPharoCodeHighlighterExamples >> variableReferenceX [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoVariableReferenceHighlighter new
		variableName: 'x';
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(20 to: 20). (823 to: 823)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #'variable reference' }
GtPharoCodeHighlighterExamples >> variableReferenceY [
	<gtExample>
	| theIntervals |
	
	theIntervals := GtPharoVariableReferenceHighlighter new
		variableName: 'y';
		accept: self exampleMethodAst.
		
	self assert: theIntervals equals: {(534 to: 534). (619 to: 619). (827 to: 827)}.

	^ self visualiseIntervals: theIntervals
]

{ #category : #private }
GtPharoCodeHighlighterExamples >> visualiseIntervals: aCollectionOfIntervals [
	| aText |
	
	aText := (self class >> self exampleMethodSelector) sourceCode asRopedText glamorousCodeFont.
	GtPharoCodeHighlighter new style: aText intervals: aCollectionOfIntervals.
	
	^ (aCollectionOfIntervals printString asRopedText glamorousCodeFont foreground: Color darkGray),
		(String cr, String cr) asRopedText,
		aText
]
