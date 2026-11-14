Class {
	#name : #GtCoderSearchReplaceTextElement,
	#superclass : #GtTextualCoderSearchTextElement,
	#instVars : [
		'replace',
		'replaceAll'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderSearchReplaceTextElement >> initialize [
	super initialize.
	self initializeReplaceElement.
	self initializeReplaceAllElement.
	self addChild: replace as: #replace.
	self addChild: replaceAll as: #replaceAll
]

{ #category : #initialization }
GtCoderSearchReplaceTextElement >> initializeReplaceAllElement [
	replaceAll := (BrButton new)
				beTinySize;
				aptitude: BrGlamorousButtonWithIconAptitude
							- BrGlamorousButtonWithLabelTooltipAptitude2;
				addAptitude: (BrGlamorousWithExplicitTooltipAptitude
							text: 'Replace all occurences in the text'
							shortcut: BlKeyCombination primaryReturn);
				margin: (BlInsets right: 3);
				label: 'Replace all occurences in the text';
				icon: BrGlamorousVectorIcons edit;
				action: [:aButton :aButtonModel :anEvent | self onReplaceAllOccurenceEvent: anEvent];
				constraintsDo: [:c | c linear vertical alignCenter]
]

{ #category : #initialization }
GtCoderSearchReplaceTextElement >> initializeReplaceElement [
	replace := (BrEditor new)
				hMatchParent;
				vFitContent;
				inputFilter: BrTextEditorNoLineBreakInputFilter new;
				aptitude: BrGlamorousRegularEditorAptitude new;
				constraintsDo: [:c | c linear vertical alignCenter].
	search addShortcut: ((BlShortcutWithAction new)
				name: 'Focus on replace';
				description: 'Focus on replace field';
				combination: BlKeyCombination tab;
				action: [:anEvent | replace requestFocus]).
	replace addShortcut: ((BlShortcutWithAction new)
				name: 'Focus on search';
				description: 'Focus on search field';
				combination: BlKeyCombination tab;
				action: [:anEvent | search requestFocus]).
	replace addShortcut: ((BlShortcutWithAction new)
				name: 'Replace all occurences';
				description: 'Replace all occurences in the text';
				combination: BlKeyCombination primaryReturn;
				action: [:anEvent | self onReplaceAllOccurenceEvent: anEvent])
]

{ #category : #initialization }
GtCoderSearchReplaceTextElement >> onReplaceAllOccurenceEvent: anEvent [
	self textualCoderViewModel
		sourceText: (self textualCoderViewModel sourceText asString
				copyReplaceAll: search text asString
				with: replace text asString) asRopedText
		from: self
		synchronously: true
]
