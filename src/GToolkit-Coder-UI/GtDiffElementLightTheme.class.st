"
The light diff palette. Initially inherits the common colors.
"
Class {
	#name : #GtDiffElementLightTheme,
	#superclass : #GtDiffElementTheme,
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #initialization }
GtDiffElementLightTheme >> initializeConstants [
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
