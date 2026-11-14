"
Examples of the standalone {{gtClass:GtDiffElement}}. Examples of splitter selection and the enclosing comparison widget are provided by {{gtClass:GtMultiSplitterDiffElementExamples}}.
"
Class {
	#name : #GtDiffElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #private }
GtDiffElementExamples >> assertLabels: fromText and: toText in: aScripter [
	aScripter
		checkStep: [ :s | 
			s
				label: 'The previous label is displayed';
				// GtDiffOldLabelId;
				do: [ :label | self assert: label text asString = fromText ] ].
	aScripter
		checkStep: [ :s | 
			s
				label: 'The proposed label is displayed';
				// GtDiffNewLabelId;
				do: [ :label | self assert: label text asString = toText ] ]
]

{ #category : #private }
GtDiffElementExamples >> assertLine: lineIndex in: editorId color: aColor scripter: aScripter [
	aScripter
		checkStep: [ :s | 
			s
				label: 'Check the rendered line background';
				// editorId;
				do: [ :editor | 
					self
						assert: ((editor children at: lineIndex) background paint color
								blocResolveColorForTheme: editor theme)
								= (aColor blocResolveColorForTheme: editor theme) ] ]
]

{ #category : #private }
GtDiffElementExamples >> assertProgress: aString in: aScripter [
	aScripter
		checkStep: [ :s | 
			s
				label: 'Check change navigation progress';
				// GtDiffButtonsId;
				// BrLabel;
				do: [ :label | self assert: label text asString = aString ] ]
]

{ #category : #private }
GtDiffElementExamples >> assertWhiteEditor: editorId in: aScripter [
	aScripter
		checkStep: [ :s | 
			s
				label: 'The editor and unchanged lines remain white';
				// editorId;
				do: [ :editor | 
					| color |
					color := editor theme diffElement editorBackgroundColor
							blocResolveColorForTheme: editor theme.
					self
						assert: (editor background paint color blocResolveColorForTheme: editor theme) = color.
					self
						assert: (editor children first background paint color
								blocResolveColorForTheme: editor theme) = color.
					self
						assert: (editor children last background paint color
								blocResolveColorForTheme: editor theme) = color ] ]
]

{ #category : #examples }
GtDiffElementExamples >> changeElementExample [
	<gtExample>
	<return: #GtDiffElement>
	^ (GtDiffElement onChange: self exampleChange) showButtons
]

{ #category : #examples }
GtDiffElementExamples >> changeElementScrollsToFirstDiff [
	<gtExample>
	<return: #GtDiffElement>
	| scripter |
	scripter := BlScripter new.
	scripter extent: 800 @ 800.
	scripter
		element: ((GtDiffElement onChange: self exampleChange)
				matchParent;
				showButtons;
				yourself).
	scripter
		checkStep: [ :s | 
			s
				label: 'Check has scrolled';
				// GtDiffButtonsId;
				// #label;
				do: [ :each | self assert: (each text asString beginsWith: '1/') ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'Can scroll text up';
				// GtDiffOldTextId;
				do: [ :each | self assert: each canScrollUp ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> changeElementWithoutScroll [
	<gtExample>
	<return: #GtDiffElement>
	| scripter |
	scripter := BlScripter new.
	scripter extent: 800 @ 800.
	scripter
		element: ((GtDiffElement onChangeWithoutScrolling: self exampleChange)
				matchParent;
				showButtons;
				yourself).
	scripter
		checkStep: [ :s | 
			s
				label: 'Check has scrolled';
				// GtDiffButtonsId;
				// #label;
				do: [ :each | self assert: (each text asString beginsWith: '0/') ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'Can scroll text up';
				// GtDiffOldTextId;
				do: [ :each | self assert: each canScrollUp not ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> changeExampleFlat [
	<gtExample>
	<return: #GtDiffElement>
	^ self changeElementExample aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElementExamples >> changeExampleShadow [
	<gtExample>
	<return: #GtDiffElement>
	^ self changeElementExample aptitude: GtDiffShadowAptitude
]

{ #category : #examples }
GtDiffElementExamples >> deletionOnly [
	<gtExample>
	<return: #BlScripter>
	| scripter previous proposed |
	previous := String cr join: #('heading' 'one two three' 'footer').
	proposed := String cr join: #('heading' 'one two' 'footer').
	scripter := self scripterFrom: previous to: proposed.
	self assertWhiteEditor: GtDiffOldTextId in: scripter.
	self assertWhiteEditor: GtDiffNewTextId in: scripter.
	self
		assertLine: 2
		in: GtDiffOldTextId
		color: scripter element theme diffElement deletedLineBackgroundColor
		scripter: scripter.
	self
		assertLine: 2
		in: GtDiffNewTextId
		color: scripter element theme diffElement unchangedSideBackgroundColor
		scripter: scripter.
	self assertProgress: '1/1' in: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> emptyElement [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := BlScripter new.
	scripter extent: 800 @ 400.
	scripter element: GtDiffElement new showButtons.
	scripter
		clickStep: [ :s | 
			s
				// GtDiffButtonsId;
				// BrButton;
				@ 2 ].
	scripter
		clickStep: [ :s | 
			s
				// GtDiffButtonsId;
				// BrButton;
				@ 1 ].
	scripter
		checkStep: [ :s | 
			s
				label: 'An empty diff has no changes';
				// GtDiffButtonsId;
				// BrLabel;
				do: [ :label | self assert: label text asString = '0/0' ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> emptyLabelsHideHeader [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self multipleChanges.
	scripter
		doStep: [ :s | 
			s
				label: 'Remove the comparison labels';
				block: [ :element | 
					element
						fromLabel: '';
						toLabel: '' ] ].
	{GtDiffOldLabelId.
		GtDiffNewLabelId}
		do: [ :labelId | 
			scripter
				checkStep: [ :s | 
					s
						label: 'Empty labels do not reserve a header row';
						// labelId;
						do: [ :label | self assert: label visibility = BlVisibility gone ] ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'The editors occupy the first grid row';
				// GtDiffOldTextId;
				do: [ :editor | self assert: editor bounds inParent top = 0 ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> emptyTexts [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterFrom: '' to: ''.
	self assertProgress: '0/0' in: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> exampleChange [
	<gtExample>
	<return: #GtCompositeDiffChange>
	^ GtDiffBuilder
		computeDifferencesFrom: self originalString
		to: self newString
		using: GtCharacterGroupDiffSplitter words ignoreWhitespace
]

{ #category : #examples }
GtDiffElementExamples >> exampleTextDiff [
	<gtExample>
	<return: #TextDiffBuilder>
	^ TextDiffBuilder from: self originalString to: self newString
]

{ #category : #examples }
GtDiffElementExamples >> hiddenDiffKeepsLabels [
	<gtExample>
	<return: #BlScripter>
	| scripter change |
	change := GtDiffBuilder
			computeDifferencesFrom: self previousText
			to: self previousText
			using: GtCharacterGroupDiffSplitter words ignoreWhitespace.
	scripter := BlScripter new.
	scripter extent: 800 @ 400.
	scripter
		element: (GtDiffElementWithLabelStencil new
				change: change;
				fromLabelText: 'Previous';
				toLabelText: 'Proposed';
				shouldHideDiff: true;
				asElement).
	self
		assertLabels: 'Previous'
		and: 'Proposed'
		in: scripter.
	{GtDiffOldTextId.
		GtDiffNewTextId.
		GtDiffButtonsId}
		do: [ :anId | 
			scripter
				checkStep: [ :s | 
					s
						label: 'Hide the comparison and navigation';
						// anId;
						do: [ :element | self assert: element visibility = BlVisibility gone ] ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> identicalTexts [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterFrom: self previousText to: self previousText.
	{GtDiffOldTextId.
		GtDiffNewTextId}
		do: [ :editorId | 
			scripter
				checkStep: [ :s | 
					s
						label: 'Identical content has no colored change regions';
						// editorId;
						do: [ :editor | 
							self
								assert: (editor background paint color blocResolveColorForTheme: editor theme)
										= (editor theme diffElement editorBackgroundColor
												blocResolveColorForTheme: editor theme).
							self
								assert: (editor children
										allSatisfy: [ :line | 
											(line background paint color blocResolveColorForTheme: editor theme)
												= (editor theme diffElement editorBackgroundColor
														blocResolveColorForTheme: editor theme) ]) ] ] ].
	self assertProgress: '0/0' in: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> insertionOnly [
	<gtExample>
	<return: #BlScripter>
	| scripter previous proposed |
	previous := String cr join: #('heading' 'one two' 'footer').
	proposed := String cr join: #('heading' 'one two three' 'footer').
	scripter := self scripterFrom: previous to: proposed.
	self assertWhiteEditor: GtDiffOldTextId in: scripter.
	self assertWhiteEditor: GtDiffNewTextId in: scripter.
	self
		assertLine: 2
		in: GtDiffOldTextId
		color: scripter element theme diffElement unchangedSideBackgroundColor
		scripter: scripter.
	self
		assertLine: 2
		in: GtDiffNewTextId
		color: scripter element theme diffElement addedLineBackgroundColor
		scripter: scripter.
	self assertProgress: '1/1' in: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> labelsAlignWithEditorText [
	<gtExample>
	<return: #BlScripter>
	| scripter leftTextX rightTextX |
	scripter := self multipleChanges.
	scripter
		checkStep: [ :s | 
			s
				label: 'Locate the previous editor text';
				// GtDiffOldTextId;
				do: [ :editor | leftTextX := editor bounds inSpace left + editor padding left ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'Locate the proposed editor text';
				// GtDiffNewTextId;
				do: [ :editor | rightTextX := editor bounds inSpace left + editor padding left ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'The previous label shares its editor text inset';
				// GtDiffOldLabelId;
				do: [ :label | self assert: label bounds inSpace left + label padding left = leftTextX ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'The proposed label shares its editor text inset';
				// GtDiffNewLabelId;
				do: [ :label | self assert: label bounds inSpace left + label padding left = rightTextX ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> multipleChanges [
	<gtExample>
	<return: #BlScripter>
	| scripter colors |
	scripter := self scripterFrom: self previousText to: self proposedText.
	colors := scripter element theme diffElement.
	self assertProgress: '1/4' in: scripter.
	self assertWhiteEditor: GtDiffOldTextId in: scripter.
	self assertWhiteEditor: GtDiffNewTextId in: scripter.
	self
		assertLine: 2
		in: GtDiffOldTextId
		color: colors unchangedSideBackgroundColor
		scripter: scripter.
	self
		assertLine: 2
		in: GtDiffNewTextId
		color: colors addedLineBackgroundColor
		scripter: scripter.
	self
		assertLine: 4
		in: GtDiffOldTextId
		color: colors deletedLineBackgroundColor
		scripter: scripter.
	self
		assertLine: 4
		in: GtDiffNewTextId
		color: colors unchangedSideBackgroundColor
		scripter: scripter.
	self
		assertLine: 7
		in: GtDiffOldTextId
		color: colors deletedLineBackgroundColor
		scripter: scripter.
	self
		assertLine: 9
		in: GtDiffNewTextId
		color: colors addedLineBackgroundColor
		scripter: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> navigateToNextChange [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self multipleChanges.
	scripter
		clickStep: [ :s | 
			s
				label: 'Go to the next change';
				// GtDiffButtonsId;
				// BrButton;
				@ 2 ].
	self assertProgress: '2/4' in: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> navigateToPreviousChange [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self navigateToNextChange.
	scripter
		clickStep: [ :s | 
			s
				label: 'Go to the previous change';
				// GtDiffButtonsId;
				// BrButton;
				@ 1 ].
	self assertProgress: '1/4' in: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> newString [
	<gtExample>
	<return: #ByteString>
	^ String
		streamContents: [ :str | 
			1
				to: 1000
				by: 6
				do: [ :i | 
					str
						print: i;
						cr;
						print: i + 1;
						cr;
						print: i + 2;
						cr ] ]
]

{ #category : #examples }
GtDiffElementExamples >> originalString [
	<gtExample>
	<return: #ByteString>
	^ String
		streamContents: [ :str | 
			1
				to: 1000
				by: 5
				do: [ :i | 
					str
						print: i;
						cr;
						print: i + 1;
						cr;
						print: i + 2;
						cr ] ]
]

{ #category : #private }
GtDiffElementExamples >> previousText [
	^ String cr
		join: #('heading' 'one two' 'middle' 'four five' 'footer' 'before removal' '' 'after removal' 'before insertion' 'after insertion' 'end')
]

{ #category : #private }
GtDiffElementExamples >> proposedText [
	^ String cr
		join: #('heading' 'one two three' 'middle' 'four' 'footer' 'before removal' 'after removal' 'before insertion' '' 'after insertion' 'end')
]

{ #category : #private }
GtDiffElementExamples >> scripterFrom: previous to: proposed [
	| scripter change |
	change := GtDiffBuilder
			computeDifferencesFrom: previous
			to: proposed
			using: GtCharacterGroupDiffSplitter words includeWhitespace.
	scripter := BlScripter new.
	scripter extent: 800 @ 400.
	scripter
		element: ((GtDiffElement onChange: change)
				aptitude: GtDiffFlatAptitude;
				matchParent;
				beSmallSize;
				fromLabel: 'Previous';
				toLabel: 'Proposed';
				moveButtonsToBottom;
				yourself).
	scripter
		checkStep: [ :s | 
			s
				label: 'Previous text is displayed';
				// GtDiffOldTextId;
				do: [ :editor | self assert: editor text asString = previous ] ].
	scripter
		checkStep: [ :s | 
			s
				label: 'Proposed text is displayed';
				// GtDiffNewTextId;
				do: [ :editor | self assert: editor text asString = proposed ] ].
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> singleLabel [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self multipleChanges.
	scripter
		doStep: [ :s | 
			s
				label: 'Keep only the proposed label';
				block: [ :element | element fromLabel: '' ] ].
	self
		assertLabels: ''
		and: 'Proposed'
		in: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementExamples >> textDiffElementExample [
	<gtExample>
	<return: #GtDiffElement>
	^ (GtDiffElement onDiff: self exampleTextDiff) showButtons
]

{ #category : #examples }
GtDiffElementExamples >> textDiffExampleFlat [
	<gtExample>
	<return: #GtDiffElement>
	^ self textDiffElementExample aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElementExamples >> textDiffExampleShadow [
	<gtExample>
	<return: #GtDiffElement>
	^ self textDiffElementExample aptitude: GtDiffShadowAptitude
]
