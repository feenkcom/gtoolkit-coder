"
Examples for the common diff palette, inherited themes, live theme changes and theme-aware fragment highlights.
"
Class {
	#name : #GtDiffElementThemeExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Diff'
}

{ #category : #private }
GtDiffElementThemeExamples >> assertCurrentPaletteFor: aTheme [
	| reference |
	reference := BrGlamorousLightTheme new.
	#(deletedLineBackgroundColor deletedTextBackgroundColor addedLineBackgroundColor addedTextBackgroundColor unchangedSideBackgroundColor connectorBackgroundColor borderColor editorBorderColor editorBackgroundColor selectedBorderColor labelForegroundColor)
		do: [ :selector | 
			self
				assert: (self color: selector in: aTheme) = (self color: selector in: reference) ]
]

{ #category : #private }
GtDiffElementThemeExamples >> assertFragment: aString in: editorId resolvedColor: aColor scripter: aScripter [
	aScripter
		checkStep: [ :s | 
			s
				label: 'The fragment highlight resolves its editor theme';
				// editorId;
				do: [ :editor | 
					| index attribute builder |
					index := editor text asString findString: aString.
					self assert: index > 0.
					attribute := (editor text attributesAt: index)
							detect: [ :each | each isKindOf: GtDiffTextHighlightAttribute ].
					builder := BlTextFontAndStyleBuilder new.
					attribute applyOnFontAndStyleBuilder: builder theme: editor theme.
					self assert: builder background = aColor ] ]
]

{ #category : #private }
GtDiffElementThemeExamples >> assertLine: lineIndex in: editorId resolvedColor: aColor scripter: aScripter [
	GtDiffElementExamples new
		assertLine: lineIndex
		in: editorId
		color: aColor
		scripter: aScripter
]

{ #category : #examples }
GtDiffElementThemeExamples >> changeHighlightColorsDelegateToTheme [
	<gtExample>
	| theme deletion insertion defaultTheme |
	defaultTheme := BlTheme default.
	deletion := GtDeletionDiffChange new.
	insertion := GtInsertionDiffChange new.
	self
		assert: deletion highlightColor == defaultTheme diffElement deletedTextBackgroundColor.
	self
		assert: insertion highlightColor == defaultTheme diffElement addedTextBackgroundColor.
	theme := self darkTheme.
	theme diffElement
		deletedTextBackgroundColor: (self color: #addedTextBackgroundColor in: defaultTheme);
		addedTextBackgroundColor: (self color: #deletedTextBackgroundColor in: defaultTheme).
	self
		assert: (deletion highlightColorForTheme: theme)
				== theme diffElement deletedTextBackgroundColor.
	self
		assert: (insertion highlightColorForTheme: theme)
				== theme diffElement addedTextBackgroundColor.
	^ theme
]

{ #category : #private }
GtDiffElementThemeExamples >> color: aSelector in: aTheme [
	^ (aTheme diffElement perform: aSelector) blocResolveColorForTheme: aTheme
]

{ #category : #examples }
GtDiffElementThemeExamples >> colorsRefreshAfterThemeModification [
	<gtExample>
	| theme color original |
	theme := self lightTheme.
	color := theme diffElement addedLineBackgroundColor.
	original := self color: #addedLineBackgroundColor in: theme.
	theme diffElement
		addedLineBackgroundColor: (self color: #deletedLineBackgroundColor in: theme).
	theme themeModified.
	self
		assert: (color blocResolveColorForTheme: theme)
				= (self color: #addedLineBackgroundColor in: theme).
	self assert: (color blocResolveColorForTheme: theme) ~= original.
	^ theme
]

{ #category : #examples }
GtDiffElementThemeExamples >> colorsResolveAgainstTargetTheme [
	<gtExample>
	| light dark color original |
	light := self lightTheme.
	dark := self darkTheme.
	color := light diffElement deletedLineBackgroundColor.
	original := self color: #deletedLineBackgroundColor in: light.
	dark diffElement
		deletedLineBackgroundColor: (self color: #addedLineBackgroundColor in: light).
	self
		assert: (color blocResolveColorForTheme: dark)
				= (self color: #deletedLineBackgroundColor in: dark).
	self assert: (color blocResolveColorForTheme: dark) ~= original.
	self assert: (color blocResolveColorForTheme: light) = original.
	^ color
]

{ #category : #examples }
GtDiffElementThemeExamples >> darkDiffElement [
	<gtExample>
	<return: #BlScripter>
	| scripter theme |
	scripter := GtDiffElementExamples new multipleChanges.
	theme := self darkTheme.
	scripter
		doStep: [ :s | 
			s
				label: 'Apply the dark theme to the diff';
				block: [ :element | 
					element
						theme: theme;
						background: theme diffElement editorBackgroundColor ] ].
	self
		assertLine: 2
		in: GtDiffOldTextId
		resolvedColor: (self color: #unchangedSideBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 2
		in: GtDiffNewTextId
		resolvedColor: (self color: #addedLineBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 4
		in: GtDiffOldTextId
		resolvedColor: (self color: #deletedLineBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 4
		in: GtDiffNewTextId
		resolvedColor: (self color: #unchangedSideBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 7
		in: GtDiffOldTextId
		resolvedColor: (self color: #deletedLineBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 9
		in: GtDiffNewTextId
		resolvedColor: (self color: #addedLineBackgroundColor in: theme)
		scripter: scripter.
	self
		assertFragment: 'old'
		in: GtDiffOldTextId
		resolvedColor: (self color: #deletedTextBackgroundColor in: theme)
		scripter: scripter.
	self
		assertFragment: 'new'
		in: GtDiffNewTextId
		resolvedColor: (self color: #addedTextBackgroundColor in: theme)
		scripter: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementThemeExamples >> darkTheme [
	<gtExample>
	| theme reference |
	theme := BrGlamorousDarkTheme new.
	reference := self lightTheme.
	self assert: theme diffElement class = GtDiffElementDarkTheme.
	#(deletedLineBackgroundColor deletedTextBackgroundColor addedLineBackgroundColor addedTextBackgroundColor unchangedSideBackgroundColor connectorBackgroundColor borderColor editorBorderColor editorBackgroundColor labelForegroundColor)
		do: [ :selector | 
			self
				assert: (self color: selector in: theme) ~= (self color: selector in: reference) ].
	self
		assert: (self color: #selectedBorderColor in: theme)
		equals: (BrGlamorousColors primaryBorderColor blocResolveColorForTheme: theme).
	^ theme
]

{ #category : #examples }
GtDiffElementThemeExamples >> labelForegroundUsesStoredThemeableColor [
	<gtExample>
	<return: #BlThemeableColor>
	| aLightTheme aDarkTheme aPaint |
	aLightTheme := self lightTheme.
	aDarkTheme := self darkTheme.
	aPaint := aLightTheme diffElement labelForegroundColor.
	self assert: (aPaint isKindOf: BlThemeableColor).
	self assert: aLightTheme diffElement labelForegroundColor == aPaint.
	self
		assert: aPaint rawColor
		equals: (aLightTheme diffElement constantAt: #labelForegroundColor).
	self
		assert: (aPaint blocResolveColorForTheme: aDarkTheme)
		equals: (aDarkTheme diffElement constantAt: #labelForegroundColor).
	^ aPaint
]

{ #category : #examples }
GtDiffElementThemeExamples >> lazyDiffSubTheme [
	<gtExample>
	| theme subtheme |
	theme := BrGlamorousLightTheme new.
	self assert: theme subThemes isEmpty.
	subtheme := theme diffElement.
	self assert: subtheme class = GtDiffElementLightTheme.
	self assert: subtheme theme == theme.
	self assert: theme subThemes size = 1.
	self assert: (theme subThemes at: #gtDiffElementTheme) == subtheme.
	self assert: theme diffElement == subtheme.
	self assertCurrentPaletteFor: theme.
	^ theme
]

{ #category : #examples }
GtDiffElementThemeExamples >> lightTheme [
	<gtExample>
	| theme |
	theme := BrGlamorousLightTheme new.
	self assert: theme diffElement class = GtDiffElementLightTheme.
	self assertCurrentPaletteFor: theme.
	^ theme
]

{ #category : #examples }
GtDiffElementThemeExamples >> livePaletteModificationUpdatesDiff [
	<gtExample>
	<return: #BlScripter>
	| scripter theme |
	scripter := self themeSwitchUpdatesDiff.
	theme := scripter element theme.
	scripter
		doStep: [ :s | 
			s
				label: 'Modify the active diff palette';
				block: [ :element | 
					theme diffElement
						addedLineBackgroundColor: (self color: #deletedLineBackgroundColor in: theme);
						addedTextBackgroundColor: (self color: #deletedTextBackgroundColor in: theme).
					theme themeModified ] ].
	self
		assertLine: 2
		in: GtDiffNewTextId
		resolvedColor: (self color: #addedLineBackgroundColor in: theme)
		scripter: scripter.
	self
		assertFragment: 'three'
		in: GtDiffNewTextId
		resolvedColor: (self color: #addedTextBackgroundColor in: theme)
		scripter: scripter.
	^ scripter
]

{ #category : #examples }
GtDiffElementThemeExamples >> nearWhiteTheme [
	<gtExample>
	| theme |
	theme := BrGlamorousNearWhiteTheme new.
	self assert: theme diffElement class = GtDiffElementLightTheme.
	self assertCurrentPaletteFor: theme.
	^ theme
]

{ #category : #examples }
GtDiffElementThemeExamples >> replaceDiffSubTheme [
	<gtExample>
	| theme original replacement color |
	theme := self lazyDiffSubTheme.
	original := theme diffElement.
	color := original addedLineBackgroundColor.
	replacement := GtDiffElementLightTheme theme: theme.
	replacement
		addedLineBackgroundColor: (self color: #deletedLineBackgroundColor in: theme).
	self assert: (replacement addedLineBackgroundColor isKindOf: BlThemeableColor).
	self
		assert: replacement addedLineBackgroundColor rawColor
		equals: (self color: #deletedLineBackgroundColor in: theme).
	theme diffElement: replacement.
	self assert: theme diffElement == replacement.
	self assert: (theme subThemes at: #gtDiffElementTheme) == replacement.
	self assert: replacement theme == theme.
	theme themeModified.
	self
		assert: (color blocResolveColorForTheme: theme)
				= (self color: #addedLineBackgroundColor in: theme).
	^ theme
]

{ #category : #examples }
GtDiffElementThemeExamples >> themeSwitchUpdatesDiff [
	<gtExample>
	<return: #BlScripter>
	| scripter theme reference |
	scripter := GtDiffElementExamples new multipleChanges.
	theme := self darkTheme.
	reference := self lightTheme.
	theme diffElement
		deletedLineBackgroundColor: (self color: #addedLineBackgroundColor in: reference);
		addedLineBackgroundColor: (self color: #deletedLineBackgroundColor in: reference);
		unchangedSideBackgroundColor: (self color: #borderColor in: reference);
		deletedTextBackgroundColor: (self color: #addedTextBackgroundColor in: reference);
		addedTextBackgroundColor: (self color: #deletedTextBackgroundColor in: reference);
		editorBackgroundColor: (self color: #connectorBackgroundColor in: reference);
		connectorBackgroundColor: (self color: #editorBackgroundColor in: reference);
		selectedBorderColor: (self color: #deletedTextBackgroundColor in: reference).
	scripter
		doStep: [ :s | 
			s
				label: 'Change the theme after the diff is rendered';
				block: [ :element | element theme: theme ] ].
	self
		assertLine: 2
		in: GtDiffOldTextId
		resolvedColor: (self color: #unchangedSideBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 2
		in: GtDiffNewTextId
		resolvedColor: (self color: #addedLineBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 4
		in: GtDiffOldTextId
		resolvedColor: (self color: #deletedLineBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 4
		in: GtDiffNewTextId
		resolvedColor: (self color: #unchangedSideBackgroundColor in: theme)
		scripter: scripter.
	self
		assertLine: 1
		in: GtDiffOldTextId
		resolvedColor: (self color: #editorBackgroundColor in: theme)
		scripter: scripter.
	self
		assertFragment: 'five'
		in: GtDiffOldTextId
		resolvedColor: (self color: #deletedTextBackgroundColor in: theme)
		scripter: scripter.
	self
		assertFragment: 'three'
		in: GtDiffNewTextId
		resolvedColor: (self color: #addedTextBackgroundColor in: theme)
		scripter: scripter.
	scripter
		checkStep: [ :s | 
			s
				label: 'Connector and selection use the inherited palette';
				onThisOrBreadthFirstChildOfKind: GtDiffElement;
				do: [ :element | 
					self assert: element theme == theme.
					self
						assert: (self color: #connectorBackgroundColor in: element theme)
								= (self color: #connectorBackgroundColor in: theme).
					self
						assert: (self color: #selectedBorderColor in: element theme)
								= (self color: #selectedBorderColor in: theme) ] ].
	^ scripter
]
