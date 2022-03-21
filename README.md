# NACC Architecture Documents

This directory contains the source for documenting NACC system architecture along with the configuration of tools to generate the files as Markdown plus images.
These documents are published as the [NACC Architecture Documents](https://naccdata.github.io/system-design).

Three forms of documentation are supported here:

1. A [C4Model](https://c4model.com) workspace (`src/structurizr/workspace.dsl`)
2. Markdown + [Mermaid](https://mermaid-js.github.io/mermaid/#/) diagrams (`src/markdown`)
3. [Architecture Decision Records](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)

The source for all documents are stored within the `src` directory, and the final generated documents are stored in `docs`.

## Managing documents


Documents should be edited in the `src` directory.
This directory is organized in a Gradle-like fashion determined by the type of file or tool used to process them.

```bash
src
├── markdown
│   ├── 01-system-landscape.md
│   ├── 02-domain-model.md
│   ├── 03-data-repository.md
│   ├── 04-directory.md
│   ├── 05-research-tracking.md
│   ├── 06-communications.md
│   ├── 07-website.md
│   ├── 14-decision-log.md
│   └── index.md
└── structurizr
    └── workspace.dsl
```

The Markdown documents are split by subsystem, with the system landscape and domain models as special cases to provide background.
The numbering of the markdown documents corresponds to the order they are included into `index.md`, but is not significant otherwise.

New markdown documents should be added to the `markdown` directory.
These documents may include Mermaid diagrams.
Any reference to C4 models needs to use links of the form
```markdown
![Label-Text](images/structurizr-DiagramName.svg)
```
where `Label-Text` is a text tag for the description, and `DiagramName` is the name for the diagram in the `workspace.dsl` file.
When published the diagrams are moved into `docs/images` so this is a direct reference in that context.

The C4 Models are generated from the `structurizr/workspace.dsl` file.
Additional model details should be added to this file, which is written using the [Structurizr DSL](https://structurizr.com/dsl).

Note that the Gradle plugin used to run the Structurizr-cli places files into the `structurizr` directory.
These are copied into the `build` directory and shouldn't be included in the repository files.

<!-- TODO: Add text about architecture decision records -->

## Publishing documents

The document generation is done using Gradle with the build described in `./build.gradle.kts`.

The documents are published to the `docs` directory by running the command

```bash
./gradlew publish
```

The script will populate the `docs` folder in a way that allows them to be viewed using GitHub Pages.

This will look something like this

```bash
docs
├── 01-system-landscape.md
├── 02-domain-model-1.svg
├── 02-domain-model-2.svg
├── 02-domain-model-3.svg
├── 02-domain-model-4.svg
├── 02-domain-model-5.svg
├── 02-domain-model.md
├── 03-data-repository-1.svg
├── 03-data-repository.md
├── 04-directory.md
├── 05-research-tracking.md
├── 06-communications.md
├── 07-website.md
├── 14-decision-log.md
├── images
│   ├── structurizr-AdministrationContainers.svg
│   ├── structurizr-CommunicationsContainers.svg
│   ├── structurizr-CommunicationsContext.svg
│   ├── structurizr-DirectoryContainers.svg
│   ├── structurizr-DirectoryContext.svg
│   ├── structurizr-GeneralizedSystemLandscape.svg
│   ├── structurizr-RepositoryContainers.svg
│   ├── structurizr-RepositoryContext.svg
│   ├── structurizr-ResearchTrackingContainers.svg
│   ├── structurizr-ResearchTrackingContext.svg
│   ├── structurizr-SystemLandscape.svg
│   ├── structurizr-ValidatorComponent.svg
│   ├── structurizr-WebsiteContainers.svg
│   └── structurizr-WebsiteContext.svg
└── index.md
```


