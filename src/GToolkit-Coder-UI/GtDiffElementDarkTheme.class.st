"
A dark diff palette with charcoal editor surfaces, muted Ant Design red and green change regions, and stronger inline highlights. Focus uses BrGlamorousColors primaryBorderColor.
"
Class {
	#name : #GtDiffElementDarkTheme,
	#superclass : #GtDiffElementTheme,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #initialization }
GtDiffElementDarkTheme >> initializeConstants [
	super initializeConstants.
	self constantAt: #deletedLineBackgroundColor put: BrAntColors darkRed1.
	self constantAt: #deletedTextBackgroundColor put: BrAntColors red8.
	self constantAt: #addedLineBackgroundColor put: BrAntColors darkGreen1.
	self constantAt: #addedTextBackgroundColor put: BrAntColors green8.
	self constantAt: #unchangedSideBackgroundColor put: BrAntColors gray9.
	self constantAt: #connectorBackgroundColor put: BrAntColors gray9.
	self constantAt: #borderColor put: BrAntColors gray8.
	self constantAt: #editorBorderColor put: BrAntColors gray9.
	self constantAt: #editorBackgroundColor put: BrAntColors gray10.
	self constantAt: #labelForegroundColor put: BrAntColors gray6
]
