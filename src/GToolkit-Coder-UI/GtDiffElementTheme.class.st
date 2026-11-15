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
		'selectedBorderColor'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #accessing }
GtDiffElementTheme >> addedLineBackgroundColor [
	^ addedLineBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> addedLineBackgroundColor: aColor [
	self constantAt: #addedLineBackgroundColor put: aColor.
	addedLineBackgroundColor := aColor
]

{ #category : #accessing }
GtDiffElementTheme >> addedTextBackgroundColor [
	^ addedTextBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> addedTextBackgroundColor: aColor [
	self constantAt: #addedTextBackgroundColor put: aColor.
	addedTextBackgroundColor := aColor
]

{ #category : #accessing }
GtDiffElementTheme >> borderColor [
	^ borderColor
]

{ #category : #accessing }
GtDiffElementTheme >> borderColor: aColor [
	self constantAt: #borderColor put: aColor.
	borderColor := aColor
]

{ #category : #accessing }
GtDiffElementTheme >> connectorBackgroundColor [
	^ connectorBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> connectorBackgroundColor: aColor [
	self constantAt: #connectorBackgroundColor put: aColor.
	connectorBackgroundColor := aColor
]

{ #category : #defaults }
GtDiffElementTheme >> defaultLabelForegroundColor [
	^ BrAntColors gray7
]

{ #category : #accessing }
GtDiffElementTheme >> deletedLineBackgroundColor [
	^ deletedLineBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> deletedLineBackgroundColor: aColor [
	self constantAt: #deletedLineBackgroundColor put: aColor.
	deletedLineBackgroundColor := aColor
]

{ #category : #accessing }
GtDiffElementTheme >> deletedTextBackgroundColor [
	^ deletedTextBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> deletedTextBackgroundColor: aColor [
	self constantAt: #deletedTextBackgroundColor put: aColor.
	deletedTextBackgroundColor := aColor
]

{ #category : #accessing }
GtDiffElementTheme >> editorBackgroundColor [
	^ editorBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> editorBackgroundColor: aColor [
	self constantAt: #editorBackgroundColor put: aColor.
	editorBackgroundColor := aColor
]

{ #category : #accessing }
GtDiffElementTheme >> editorBorderColor [
	^ editorBorderColor
]

{ #category : #accessing }
GtDiffElementTheme >> editorBorderColor: aColor [
	self constantAt: #editorBorderColor put: aColor.
	editorBorderColor := aColor
]

{ #category : #initialization }
GtDiffElementTheme >> initializeColors [
	super initializeColors.
	deletedLineBackgroundColor := self constantAt: #deletedLineBackgroundColor.
	deletedTextBackgroundColor := self constantAt: #deletedTextBackgroundColor.
	addedLineBackgroundColor := self constantAt: #addedLineBackgroundColor.
	addedTextBackgroundColor := self constantAt: #addedTextBackgroundColor.
	unchangedSideBackgroundColor := self constantAt: #unchangedSideBackgroundColor.
	connectorBackgroundColor := self constantAt: #connectorBackgroundColor.
	borderColor := self constantAt: #borderColor.
	editorBorderColor := self constantAt: #editorBorderColor.
	editorBackgroundColor := self constantAt: #editorBackgroundColor.
	selectedBorderColor := self constantAt: #selectedBorderColor
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
	self constantAt: #selectedBorderColor put: BrGlamorousColors primaryBorderColor
]

{ #category : #initialization }
GtDiffElementTheme >> initializeThemeable [
	super initializeThemeable.
	deletedLineBackgroundColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #deletedLineBackgroundColor ]
			source: [ :aTheme | aTheme diffElement deletedLineBackgroundColor ].
	deletedTextBackgroundColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #deletedTextBackgroundColor ]
			source: [ :aTheme | aTheme diffElement deletedTextBackgroundColor ].
	addedLineBackgroundColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #addedLineBackgroundColor ]
			source: [ :aTheme | aTheme diffElement addedLineBackgroundColor ].
	addedTextBackgroundColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #addedTextBackgroundColor ]
			source: [ :aTheme | aTheme diffElement addedTextBackgroundColor ].
	unchangedSideBackgroundColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #unchangedSideBackgroundColor ]
			source: [ :aTheme | aTheme diffElement unchangedSideBackgroundColor ].
	connectorBackgroundColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #connectorBackgroundColor ]
			source: [ :aTheme | aTheme diffElement connectorBackgroundColor ].
	borderColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #borderColor ]
			source: [ :aTheme | aTheme diffElement borderColor ].
	editorBorderColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #editorBorderColor ]
			source: [ :aTheme | aTheme diffElement editorBorderColor ].
	editorBackgroundColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #editorBackgroundColor ]
			source: [ :aTheme | aTheme diffElement editorBackgroundColor ].
	selectedBorderColor := self
			color: [ :aTheme | aTheme diffElement constantAt: #selectedBorderColor ]
			source: [ :aTheme | aTheme diffElement selectedBorderColor ]
]

{ #category : #accessing }
GtDiffElementTheme >> labelForegroundColor [
	^ self
		color: [ :aTheme | aTheme diffElement defaultLabelForegroundColor ]
		source: [ :aTheme | aTheme diffElement labelForegroundColor ]
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
	self constantAt: #selectedBorderColor put: aColor.
	selectedBorderColor := aColor
]

{ #category : #accessing }
GtDiffElementTheme >> unchangedSideBackgroundColor [
	^ unchangedSideBackgroundColor
]

{ #category : #accessing }
GtDiffElementTheme >> unchangedSideBackgroundColor: aColor [
	self constantAt: #unchangedSideBackgroundColor put: aColor.
	unchangedSideBackgroundColor := aColor
]
