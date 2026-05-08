import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  bookSidebar: [
    {
      type: 'doc',
      id: 'introduction',
      label: 'Introduction',
    },
    {
      type: 'category',
      label: 'Foundations',
      collapsed: false,
      items: [
        {type: 'doc', id: 'algorithms-and-data-structures', label: '1. Algorithms and Data Structures'},
        {type: 'doc', id: 'sql-and-nosql', label: '2. SQL and NoSQL Databases'},
      ],
    },
    {
      type: 'category',
      label: 'Infrastructure and Cloud',
      collapsed: true,
      items: [
        {type: 'doc', id: 'docker-and-kubernetes', label: '3. Docker and Kubernetes'},
        {type: 'doc', id: 'aws', label: '4. AWS'},
      ],
    },
    {
      type: 'category',
      label: 'Languages and Frameworks',
      collapsed: true,
      items: [
        {type: 'doc', id: 'javascript', label: '5. JavaScript'},
        {type: 'doc', id: 'typescript', label: '6. TypeScript'},
        {type: 'doc', id: 'angular', label: '7. Angular'},
        {type: 'doc', id: 'react', label: '8. React'},
        {type: 'doc', id: 'nextjs', label: '9. Next.js'},
        {type: 'doc', id: 'nodejs', label: '10. Node.js'},
        {type: 'doc', id: 'python', label: '11. Python'},
      ],
    },
    {
      type: 'category',
      label: 'Architecture and Design',
      collapsed: true,
      items: [
        {type: 'doc', id: 'api-design', label: '12. API Design'},
        {type: 'doc', id: 'system-design', label: '13. System Design'},
        {type: 'doc', id: 'software-architecture', label: '14. Software Architecture'},
      ],
    },
    {
      type: 'category',
      label: 'Operations and Quality',
      collapsed: true,
      items: [
        {type: 'doc', id: 'security', label: '15. Security'},
        {type: 'doc', id: 'testing-and-quality', label: '16. Testing and Quality'},
        {type: 'doc', id: 'ci-cd-and-devops', label: '17. CI/CD and DevOps'},
        {type: 'doc', id: 'observability', label: '18. Observability'},
        {type: 'doc', id: 'performance-and-scalability', label: '19. Performance and Scalability'},
      ],
    },
    {
      type: 'category',
      label: 'Process and Leadership',
      collapsed: true,
      items: [
        {type: 'doc', id: 'git-and-engineering-workflow', label: '20. Git and Engineering Workflow'},
        {type: 'doc', id: 'ai-usage-in-software-engineering', label: '21. AI Usage in Software Engineering'},
        {type: 'doc', id: 'soft-skills', label: '22. Soft Skills'},
        {type: 'doc', id: 'tech-lead-skills', label: '23. Tech Lead Skills'},
      ],
    },
    {
      type: 'category',
      label: 'Interview Preparation',
      collapsed: false,
      items: [
        {type: 'doc', id: 'interview-questions-and-answers', label: '24. Interview Questions and Answers'},
        {type: 'doc', id: 'practical-interview-scenarios', label: '25. Practical Interview Scenarios'},
      ],
    },
    {
      type: 'doc',
      id: 'glossary',
      label: 'Glossary',
    },
  ],
};

export default sidebars;
