Class {
	#name : #GtTextualCoderViewModelStyledTextChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'styledText'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #generated }
GtTextualCoderViewModelStyledTextChanged >> styledText [
	<objectGetter: #textualCoder>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectGetterTemplate'>

	^ styledText
]

{ #category : #generated }
GtTextualCoderViewModelStyledTextChanged >> styledText: aStyledText [
	<objectSetter: #textualCoder>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectSetterTemplate'>

	styledText := aStyledText
]
