Class {
	#name : #GtCoderSearchReplaceTextElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> coderViewModel [
	<gtExample>
	^(GtPharoSnippetCoder forSource: 'a := 1. a + a') asCoderViewModel
]

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> replaceAllByButton [
	<gtExample>
	| aScripter |
	aScripter := self scripterWithSearch: 'a' replace: 'b'.
	(aScripter click)
		label: 'Click replace all';
		onChildNamed: #replaceAll;
		play.
	self assert: (self sourceStringOf: aScripter) equals: 'b := 1. b + b'.
	^aScripter
]

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> replaceAllByShortcut [
	<gtExample>
	| aScripter |
	aScripter := self scripterWithSearch: 'a' replace: 'b'.
	(aScripter shortcut)
		label: 'Replace all with primary+Return';
		combination: BlKeyCombination primaryReturn;
		onChildNamed: #replace;
		play.
	self assert: (self sourceStringOf: aScripter) equals: 'b := 1. b + b'.
	^aScripter
]

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> replaceAllWithEmptyReplacement [
	<gtExample>
	| aScripter |
	aScripter := self scripterWithSearch: ' + a' replace: ''.
	(aScripter click)
		label: 'Click replace all';
		onChildNamed: #replaceAll;
		play.
	self assert: (self sourceStringOf: aScripter) equals: 'a := 1. a'.
	^aScripter
]

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> replaceAllWithoutMatch [
	<gtExample>
	| aScripter |
	aScripter := self scripterWithSearch: 'zzz' replace: 'b'.
	(aScripter click)
		label: 'Click replace all';
		onChildNamed: #replaceAll;
		play.
	self assert: (self sourceStringOf: aScripter) equals: 'a := 1. a + a'.
	^aScripter
]

{ #category : #utilities }
GtCoderSearchReplaceTextElementExamples >> scripterWithSearch: aSearchString replace: aReplaceString [
	| anElement aScripter |
	anElement := self searchReplaceElement.
	(anElement childNamed: #pattern) text: aSearchString asRopedText.
	(anElement childNamed: #replace) text: aReplaceString asRopedText.
	aScripter := BlScripter new.
	aScripter element: anElement.
	^aScripter
]

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> searchReplaceElement [
	<gtExample>
	| anElement |
	anElement := GtCoderSearchReplaceTextElement new
				textualCoderViewModel: self coderViewModel.
	self assert: (anElement childNamed: #pattern) notNil.
	self assert: (anElement childNamed: #replace) notNil.
	self assert: (anElement childNamed: #replaceAll) notNil.
	^anElement
]

{ #category : #utilities }
GtCoderSearchReplaceTextElementExamples >> sourceStringOf: aScripter [
	^aScripter element textualCoderViewModel sourceText asString
]

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> tabMovesFocusFromReplaceToSearch [
	<gtExample>
	| aScripter |
	aScripter := self tabMovesFocusFromSearchToReplace.
	(aScripter shortcut)
		label: 'Tab in replace field';
		combination: BlKeyCombination tab;
		onChildNamed: #replace;
		play.
	(aScripter assert)
		label: 'Search field is focused';
		satisfies: [:anEditor | anEditor isFocused];
		onChildNamed: #pattern;
		play.
	^aScripter
]

{ #category : #examples }
GtCoderSearchReplaceTextElementExamples >> tabMovesFocusFromSearchToReplace [
	<gtExample>
	| aScripter |
	aScripter := self scripterWithSearch: 'a' replace: 'b'.
	(aScripter shortcut)
		label: 'Tab in search field';
		combination: BlKeyCombination tab;
		onChildNamed: #pattern;
		play.
	(aScripter assert)
		label: 'Replace field is focused';
		satisfies: [:anEditor | anEditor isFocused];
		onChildNamed: #replace;
		play.
	^aScripter
]
