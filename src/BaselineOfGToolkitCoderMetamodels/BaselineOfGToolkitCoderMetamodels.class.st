Class {
	#name : #BaselineOfGToolkitCoderMetamodels,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitCoderMetamodels
}

{ #category : #baseline }
BaselineOfGToolkitCoderMetamodels >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: 'GToolkitRefactoringsUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.8.9/src' ].
		spec package: 'GToolkit-Coder-Metamodels' with: [
				spec requires: #('GToolkitRefactoringsUtility' ). ]. ].

]
