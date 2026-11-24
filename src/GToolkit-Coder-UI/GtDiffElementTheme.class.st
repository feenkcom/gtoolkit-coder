"
Semantic colors and ribbon measurements for a diff element. Themeable colors resolve through the owning theme's diffElement subtheme. Light and dark subclasses can provide different palette constants.
"
Class {
	#name : #GtDiffElementTheme,
	#superclass : #BlSubTheme,
	#instVars : [
		'deletedLineBackgroundColor',
		'deletedTextBackgroundColor',
		'addedLineBackgroundColor',
		'addedTextBackgroundColor',
		'unchangedSideBackgroundColor',
		'connectorBackgroundColor',
		'borderColor',
		'editorBorderColor',
		'editorBackgroundColor',
		'selectedBorderColor',
		'labelForegroundColor'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #accessing }
GtDiffElementTheme >> addedLineBackgroundColor [
	^ addedLineBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> addedLineBackgroundColor: aColor [
	self
		constantAt: #addedLineBackgroundColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> addedTextBackgroundColor [
	^ addedTextBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> addedTextBackgroundColor: aColor [
	self
		constantAt: #addedTextBackgroundColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> borderColor [
	^ borderColor
]

{ #category : #accessing }
GtDiffElementTheme >> borderColor: aColor [
	self
		constantAt: #borderColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> connectorBackgroundColor [
	^ connectorBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> connectorBackgroundColor: aColor [
	self
		constantAt: #connectorBackgroundColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> deletedLineBackgroundColor [
	^ deletedLineBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> deletedLineBackgroundColor: aColor [
	self
		constantAt: #deletedLineBackgroundColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> deletedTextBackgroundColor [
	^ deletedTextBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> deletedTextBackgroundColor: aColor [
	self
		constantAt: #deletedTextBackgroundColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> editorBackgroundColor [
	^ editorBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> editorBackgroundColor: aColor [
	self
		constantAt: #editorBackgroundColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> editorBorderColor [
	^ editorBorderColor
]

{ #category : #accessing }
GtDiffElementTheme >> editorBorderColor: aColor [
	self
		constantAt: #editorBorderColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #initialization }
GtDiffElementTheme >> initializeConstants [
	super initializeConstants.
	self constantAt: #deletedLineBackgroundColor put: BrAntColors red0.
	self constantAt: #deletedTextBackgroundColor put: BrAntColors red1.
	self constantAt: #addedLineBackgroundColor put: BrAntColors green0.
	self constantAt: #addedTextBackgroundColor put: BrAntColors green1.
	self constantAt: #unchangedSideBackgroundColor put: BrAntColors gray2.
	self constantAt: #connectorBackgroundColor put: BrAntColors gray2.
	self constantAt: #borderColor put: BrAntColors gray4.
	self constantAt: #editorBorderColor put: BrAntColors gray3.
	self constantAt: #editorBackgroundColor put: BrAntColors gray0.
	self constantAt: #selectedBorderColor put: BrGlamorousColors primaryBorderColor.
	self constantAt: #labelForegroundColor put: BrAntColors gray7
]

{ #category : #initialization }
GtDiffElementTheme >> initializeThemeable [
	super initializeThemeable.
	deletedLineBackgroundColor := self
			color: [ :aTheme | self constantAt: #deletedLineBackgroundColor ]
			source: [ :aTheme | aTheme diffElement deletedLineBackgroundColor ].
	deletedTextBackgroundColor := self
			color: [ :aTheme | self constantAt: #deletedTextBackgroundColor ]
			source: [ :aTheme | aTheme diffElement deletedTextBackgroundColor ].
	addedLineBackgroundColor := self
			color: [ :aTheme | self constantAt: #addedLineBackgroundColor ]
			source: [ :aTheme | aTheme diffElement addedLineBackgroundColor ].
	addedTextBackgroundColor := self
			color: [ :aTheme | self constantAt: #addedTextBackgroundColor ]
			source: [ :aTheme | aTheme diffElement addedTextBackgroundColor ].
	unchangedSideBackgroundColor := self
			color: [ :aTheme | self constantAt: #unchangedSideBackgroundColor ]
			source: [ :aTheme | aTheme diffElement unchangedSideBackgroundColor ].
	connectorBackgroundColor := self
			color: [ :aTheme | self constantAt: #connectorBackgroundColor ]
			source: [ :aTheme | aTheme diffElement connectorBackgroundColor ].
	borderColor := self
			color: [ :aTheme | self constantAt: #borderColor ]
			source: [ :aTheme | aTheme diffElement borderColor ].
	editorBorderColor := self
			color: [ :aTheme | self constantAt: #editorBorderColor ]
			source: [ :aTheme | aTheme diffElement editorBorderColor ].
	editorBackgroundColor := self
			color: [ :aTheme | self constantAt: #editorBackgroundColor ]
			source: [ :aTheme | aTheme diffElement editorBackgroundColor ].
	selectedBorderColor := self
			color: [ :aTheme | self constantAt: #selectedBorderColor ]
			source: [ :aTheme | aTheme diffElement selectedBorderColor ].
	labelForegroundColor := self
			color: [ :aTheme | self constantAt: #labelForegroundColor ]
			source: [ :aTheme | aTheme diffElement labelForegroundColor ]
]

{ #category : #accessing }
GtDiffElementTheme >> labelForegroundColor [
	^ labelForegroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> ribbonBorderWidth [
	^ 1
]

{ #category : #accessing }
GtDiffElementTheme >> ribbonCornerRadius [
	^ 4
]

{ #category : #accessing }
GtDiffElementTheme >> selectedBorderColor [
	^ selectedBorderColor
]

{ #category : #accessing }
GtDiffElementTheme >> selectedBorderColor: aColor [
	self
		constantAt: #selectedBorderColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]

{ #category : #accessing }
GtDiffElementTheme >> unchangedSideBackgroundColor [
	^ unchangedSideBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> unchangedSideBackgroundColor: aColor [
	self
		constantAt: #unchangedSideBackgroundColor
		put: (aColor blocResolveColorForTheme: self theme).
	self initializeThemeable
]
