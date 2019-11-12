"
!Coder

Coder is a set of components for creating and manipulating code.

!!Method coder

The smallest unit is the ${class:GtMethodCoder}$ which, as the name says, focuses on edtiring one single method.

${example:GtMethodCoderExamples>>#keywordSelectorCoder|noCode=|previewShow=#gtLiveFor:|previewHeight=150}$

The method coder can mold dynamically to fit the context of the current method. For example, when the method is annotated with ==<gtExample>==, the coder is embellished with the possibility to run the method as an example, and see the result as a label. This happens dynamically. Give it a try below.

${example:GtMethodCoderExamples>>#thisMethod|noCode=|previewShow=#gtLiveFor:|previewHeight=300}$


!!Filters

Method coders can be combined in different ways for different purposes. One of these purposes is searching. This is achieved by means of ${class:GtCoderMethodsFilter}$.

For example, below you see the result of a code query. Expanding the resulting method coders highlights the specific nodes that matched the query.

${example:GtMethodsCoderFilterExamples>>#gtExamplePragmasAndReferencesToMethodCoder|previewExpanded=|previewShow=#gtItemsFor:|codeExpanded=false}$

See ${class:GtMethodsCoderFilterExamples}$ for more details.
"
Class {
	#name : #BaselineOfGToolkitCoder,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitCoder
}

{ #category : #baseline }
BaselineOfGToolkitCoder >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'Brick' with: [
				spec repository: 'github://feenkcom/Brick:v0.7.158/src' ];
			baseline: 'GToolkitUtility' with: [
				spec repository: 'github://feenkcom/gtoolkit-utility:v0.7.4/src' ].
		spec 
			package: 'GToolkit-Coder' with: [
				spec requires: #('Brick' 'GToolkitUtility' ). ];
			package: 'GToolkit-Coder-Examples-SystemS1';
			package: 'GToolkit-Coder-Examples' with: [
				spec requires: #('GToolkit-Coder' 'GToolkit-Coder-Examples-SystemS1' ). ]. ].

]
